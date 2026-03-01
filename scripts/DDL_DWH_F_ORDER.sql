-- dwh.f_order definition

-- Drop table

-- DROP TABLE dwh.f_order;

CREATE TABLE dwh.f_order (
	order_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	product_id int8 NOT NULL,
	craftsman_id int8 NOT NULL,
	customer_id int8 NOT NULL,
	order_created_date date NULL,
	order_completion_date date NULL,
	order_status varchar NOT NULL,
	load_dttm timestamp NOT NULL,
	CONSTRAINT orders_pk PRIMARY KEY (order_id)
);


-- dwh.f_order foreign keys

ALTER TABLE dwh.f_order ADD CONSTRAINT orders_craftsman_fk FOREIGN KEY (craftsman_id) REFERENCES dwh.d_craftsman(craftsman_id) ON DELETE RESTRICT;
ALTER TABLE dwh.f_order ADD CONSTRAINT orders_customer_fk FOREIGN KEY (customer_id) REFERENCES dwh.d_customer(customer_id) ON DELETE RESTRICT;
ALTER TABLE dwh.f_order ADD CONSTRAINT orders_product_fk FOREIGN KEY (product_id) REFERENCES dwh.d_product(product_id) ON DELETE RESTRICT;