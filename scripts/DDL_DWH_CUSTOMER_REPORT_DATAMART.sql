DROP TABLE IF EXISTS dwh.customer_report_datamart;
CREATE TABLE IF NOT EXISTS dwh.customer_report_datamart
(
  id bigserial primary key,
  customer_id bigint not null constraint customer_id_fk references dwh.d_customer(customer_id),
  customer_full_name varchar(45) not null,
  customer_address varchar(120) not null,
  customer_birthday date not null,
  customer_email varchar(55) not null check(customer_email ~*'^[A-Za-z0-9._-]+@[A-Za-z0-9._-]+\.[A-Za-z]+$'),
  customer_spent_amount decimal not null check(customer_spent_amount > 0),
  platform_earned_amount decimal not null check(platform_earned_amount > 0),
  number_of_orders smallint not null check(number_of_orders > 0),
  avg_order_cost decimal not null check(avg_order_cost > 0),
  median_order_done_time float check(median_order_done_time >= 0),
  top_category varchar(40) not null,
  top_master_id bigint not null constraint craftsman_id_fk references dwh.d_craftsman(craftsman_id),
  number_of_created_orders smallint not null check(number_of_created_orders >= 0),
  number_of_in_progress_orders smallint not null check(number_of_in_progress_orders >= 0),  
  number_of_in_deliver_orders smallint not null check(number_of_in_deliver_orders >= 0),
  number_of_done_orders smallint not null check(number_of_done_orders >= 0),
  number_of_not_done_orders smallint not null check(number_of_not_done_orders >= 0),
  report_period text not null
);
