-- source2.craft_market_orders_customers definition

-- Drop table

-- DROP TABLE source2.craft_market_orders_customers;

CREATE TABLE source2.craft_market_orders_customers (
	order_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	craftsman_id int8 NOT NULL,
	product_id int8 NOT NULL,
	order_created_date date NULL,
	order_completion_date date NULL,
	order_status varchar NOT NULL,
	customer_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	customer_name varchar NULL,
	customer_address varchar NOT NULL,
	customer_birthday date NULL,
	customer_email varchar NOT NULL,
	CONSTRAINT craft_market_orders_customers_pk PRIMARY KEY (order_id)
);


-- source2.craft_market_orders_customers foreign keys

ALTER TABLE source2.craft_market_orders_customers ADD CONSTRAINT craft_market_orders_customers_fk FOREIGN KEY (craftsman_id) REFERENCES source2.craft_market_masters_products(craftsman_id) ON DELETE RESTRICT;