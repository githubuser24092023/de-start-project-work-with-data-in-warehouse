DROP TABLE IF EXISTS dwh.load_dates_customer_report_datamart;

CREATE TABLE IF NOT EXISTS dwh.load_dates_customer_report_datamart (
    id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    load_dt DATE NOT NULL,
    CONSTRAINT load_dates_customer_report_datamart_pk PRIMARY KEY (id)
);


	WITH dwh_delta AS ( -- определяем, какие данные были изменены в витрине или добавлены в DWH. Формируем дельту изменений
	    SELECT     
	            dcs.customer_id,
	            dcs.customer_name,
	            dcs.customer_address,
	            dcs.customer_birthday,
	            dcs.customer_email,
	            fo.order_id,
	            dp.product_id,
	            dp.product_price,
	            dp.product_type,
				dc.craftsman_id,
	            DATE_PART('year', AGE(dcs.customer_birthday)) AS customer_age,
	            fo.order_completion_date - fo.order_created_date AS diff_order_date, 
	            fo.order_status,
	            TO_CHAR(fo.order_created_date, 'yyyy-mm') AS report_period,
	            r.customer_id is null AS is_customer_new,
	            greatest(dc.load_dttm, dcs.load_dttm, dp.load_dttm) AS load_dttm
	            FROM dwh.f_order fo 
	                INNER JOIN dwh.d_craftsman dc ON fo.craftsman_id = dc.craftsman_id 
	                INNER JOIN dwh.d_customer dcs ON fo.customer_id = dcs.customer_id 
	                INNER JOIN dwh.d_product dp ON fo.product_id = dp.product_id 
	                LEFT JOIN dwh.customer_report_datamart r ON dcs.customer_id = r.customer_id
	                    WHERE (fo.load_dttm > (SELECT COALESCE(MAX(load_dt), '1900-01-01'::date) FROM dwh.load_dates_customer_report_datamart)) OR
	                            (dc.load_dttm > (SELECT COALESCE(MAX(load_dt), '1900-01-01'::date) FROM dwh.load_dates_customer_report_datamart)) OR
	                            (dcs.load_dttm > (SELECT COALESCE(MAX(load_dt), '1900-01-01'::date) FROM dwh.load_dates_customer_report_datamart)) OR
	                            (dp.load_dttm > (SELECT COALESCE(MAX(load_dt), '1900-01-01'::date) FROM dwh.load_dates_customer_report_datamart))
	),
	dwh_delta_insert_result AS ( -- делаем расчёт витрины по новым данным. Этой информации по мастерам в рамках расчётного периода раньше не было, это новые данные. Их можно просто вставить (insert) в витрину без обновления
        select 
	        dd.customer_id, 
	        dd.customer_name,
			dd.customer_address,
			dd.customer_birthday,
			dd.customer_email,
			dd.customer_spent_amount,
			dd.platform_earned_amount,
			dd.number_of_orders,
			dd.avg_order_cost,
			dd.median_order_done_time,
			pr.product_type as top_category,
			cr.craftsman_id as top_master_id,
		    dd.number_of_created_orders, 
		    dd.number_of_in_progress_orders, 
		    dd.number_of_in_deliver_orders, 
		    dd.number_of_done_orders, 
		    dd.number_of_not_done_orders,
			dd.report_period
        from
        (
		    select 
	            dd.customer_id, 
	            dd.customer_name,
				dd.customer_address,
				dd.customer_birthday,
				dd.customer_email,
				sum(dd.product_price) as customer_spent_amount,
				0.1 * sum(dd.product_price) as platform_earned_amount,
				count(dd.order_id) as number_of_orders,
				avg(dd.product_price) as avg_order_cost,
				percentile_cont(0.5) within group(order by dd.diff_order_date) as median_order_done_time,
		        sum(case when dd.order_status =   'created'   then 1 else 0 end) as number_of_created_orders, 
		        sum(case when dd.order_status = 'in progress' then 1 else 0 end) as number_of_in_progress_orders, 
		        sum(case when dd.order_status =   'delivery'  then 1 else 0 end) as number_of_in_deliver_orders, 
		        sum(case when dd.order_status =     'done' 	  then 1 else 0 end) as number_of_done_orders, 
		        sum(case when dd.order_status !=    'done' 	  then 1 else 0 end) as number_of_not_done_orders,
				report_period
	          from dwh_delta dd
			  where dd.is_customer_new = 1::bool
	          group by 
	              dd.customer_id, 
	              dd.customer_name,
				  dd.customer_address,
			  	  dd.customer_birthday,
				  dd.customer_email,
				  dd.report_period
		  ) dd
            join
			(
              select customer_id, product_type, row_number() over(partition by customer_id, product_type order by n desc) as n from
				(
				  select customer_id, product_type, count(1) as r from dwh_delta
	                where is_customer_new = 1::bool
	                group by customer_id, product_type
				) N
			) pr 
              on dd.customer_id = pr.customer_id
                and pr.n = 1
            join
			(
              select customer_id, craftsman_id, row_number() over(partition by customer_id, craftsman_id order by n desc) as n from
				(
				  select customer_id, craftsman_id, count(1) as r from dwh_delta
	                where is_customer_new = 1::bool
	                group by customer_id, craftsman_id
				) N
			) cr 
              on dd.customer_id = cr.customer_id
                and cr.n = 1
	),
	dwh_delta_update_result AS ( -- делаем перерасчёт для существующих записей витринs, так как данные обновились за отчётные периоды. Логика похожа на insert, но нужно достать конкретные данные из DWH
        select 
	        dd.customer_id, 
	        dd.customer_name,
			dd.customer_address,
			dd.customer_birthday,
			dd.customer_email,
			dd.customer_spent_amount,
			dd.platform_earned_amount,
			dd.number_of_orders,
			dd.avg_order_cost,
			dd.median_order_done_time,
			pr.product_type as top_category,
			cr.craftsman_id as top_master_id,
		    dd.number_of_created_orders, 
		    dd.number_of_in_progress_orders, 
		    dd.number_of_in_deliver_orders, 
		    dd.number_of_done_orders, 
		    dd.number_of_not_done_orders,
			dd.report_period
        from
        (
		    select 
	            dd.customer_id, 
	            dd.customer_name,
				dd.customer_address,
				dd.customer_birthday,
				dd.customer_email,
				sum(dd.product_price) as customer_spent_amount,
				0.1 * sum(dd.product_price) as platform_earned_amount,
				count(dd.order_id) as number_of_orders,
				avg(dd.product_price) as avg_order_cost,
				percentile_cont(0.5) within group(order by dd.diff_order_date) as median_order_done_time,
		        sum(case when dd.order_status =   'created'   then 1 else 0 end) as number_of_created_orders, 
		        sum(case when dd.order_status = 'in progress' then 1 else 0 end) as number_of_in_progress_orders, 
		        sum(case when dd.order_status =   'delivery'  then 1 else 0 end) as number_of_in_deliver_orders, 
		        sum(case when dd.order_status =     'done' 	  then 1 else 0 end) as number_of_done_orders, 
		        sum(case when dd.order_status !=    'done' 	  then 1 else 0 end) as number_of_not_done_orders,
				report_period
	          from dwh_delta dd
			  where dd.is_customer_new = 0::bool
	          group by 
	              dd.customer_id, 
	              dd.customer_name,
				  dd.customer_address,
			  	  dd.customer_birthday,
				  dd.customer_email,
				  dd.report_period
		  ) dd
            join
			(
              select customer_id, product_type, row_number() over(partition by customer_id, product_type order by n desc) as n from
				(
				  select customer_id, product_type, count(1) as r from dwh_delta
	                where is_customer_new = 0::bool
	                group by customer_id, product_type
				) N
			) pr 
              on dd.customer_id = pr.customer_id
                and pr.n = 1
            join
			(
              select customer_id, craftsman_id, row_number() over(partition by customer_id, craftsman_id order by n desc) as n from
				(
				  select customer_id, craftsman_id, count(1) as r from dwh_delta
	                where is_customer_new = 0::bool
	                group by customer_id, craftsman_id
				) N
			) cr 
              on dd.customer_id = cr.customer_id
                and cr.n = 1
	),
	insert_delta AS ( -- выполняем insert новых расчитанных данных для витрины 
		insert into dwh.customer_report_datamart 
		(
		  customer_id,		  			customer_full_name,		  	  	customer_address,		  		customer_birthday,
		  customer_email,		  		customer_spent_amount,		  	platform_earned_amount,			number_of_orders,
		  avg_order_cost,		  		median_order_done_time,		  	top_category,		  			top_master_id,
		  number_of_created_orders,		number_of_in_progress_orders, 	number_of_in_deliver_orders,	number_of_done_orders,
		  number_of_not_done_orders,	report_period
		) SELECT 
			  customer_id,		  			customer_name,		  	  	customer_address,		  		customer_birthday,
			  customer_email,		  		customer_spent_amount,		  	platform_earned_amount,			number_of_orders,
			  avg_order_cost,		  		median_order_done_time,		  	top_category,		  			top_master_id,
			  number_of_created_orders,		number_of_in_progress_orders, 	number_of_in_deliver_orders,	number_of_done_orders,
			  number_of_not_done_orders,	report_period
	        FROM dwh_delta_insert_result
	),
	update_delta AS ( -- выполняем обновление показателей в отчёте по уже существующим мастерам
	    UPDATE dwh.customer_report_datamart SET	  		
			customer_full_name = upd.customer_name,		  	  	
			customer_address = upd.customer_address,		  		
			customer_birthday = upd.customer_birthday,
			customer_email = upd.customer_email,		  		
			customer_spent_amount = upd.customer_spent_amount,		  	
			platform_earned_amount = upd.platform_earned_amount,			
			number_of_orders = upd.number_of_orders,
		  	avg_order_cost = upd.avg_order_cost,		  		
			median_order_done_time = upd.median_order_done_time,		  	
			top_category = upd.top_category,		  			
			top_master_id = upd.top_master_id,
		  	number_of_created_orders = upd.number_of_created_orders,	
			number_of_in_progress_orders = upd.number_of_in_progress_orders, 	
			number_of_in_deliver_orders = upd.number_of_in_deliver_orders,	
			number_of_done_orders = upd.number_of_done_orders,
		  	number_of_not_done_orders = upd.number_of_not_done_orders,	
			report_period = upd.report_period
	    FROM 
        (
	        SELECT 
	            customer_id,		  		customer_name,		  	  	customer_address,		  		customer_birthday,
			    customer_email,		  		customer_spent_amount,		  	platform_earned_amount,			number_of_orders,
			    avg_order_cost,		  		median_order_done_time,		  	top_category,		  			top_master_id,
			    number_of_created_orders,	number_of_in_progress_orders, 	number_of_in_deliver_orders,	number_of_done_orders,
			    number_of_not_done_orders,	report_period
	          FROM dwh_delta_update_result
         ) AS upd
	    WHERE dwh.customer_report_datamart.customer_id = upd.customer_id
	),
	insert_load_date AS ( -- делаем запись в таблицу загрузок о том, когда была совершена загрузка, чтобы в следующий раз взять данные, которые будут добавлены или изменены после этой даты
	    INSERT INTO dwh.load_dates_customer_report_datamart (load_dt)
	      SELECT GREATEST(COALESCE(MAX(load_dttm), NOW())) FROM dwh_delta
	)
	SELECT 'done'; -- инициализируем запрос CTE	