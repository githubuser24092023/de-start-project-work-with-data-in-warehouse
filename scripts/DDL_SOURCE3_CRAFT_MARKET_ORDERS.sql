-- source3.craft_market_orders definition

-- Drop table

-- DROP TABLE source3.craft_market_orders;

CREATE TABLE source3.craft_market_orders (
	order_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	product_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	craftsman_id int8 NOT NULL,
	customer_id int8 NOT NULL,
	order_created_date date NULL,
	order_completion_date date NULL,
	order_status varchar NOT NULL,
	product_name varchar NOT NULL,
	product_description varchar NOT NULL,
	product_type varchar NOT NULL,
	product_price int8 NOT NULL,
	CONSTRAINT craft_market_orders_pk PRIMARY KEY (order_id)
);


-- source3.craft_market_orders foreign keys

ALTER TABLE source3.craft_market_orders ADD CONSTRAINT craft_market_orders_craftsmans_fk FOREIGN KEY (craftsman_id) REFERENCES source3.craft_market_craftsmans(craftsman_id) ON DELETE RESTRICT;
ALTER TABLE source3.craft_market_orders ADD CONSTRAINT craft_market_orders_customers_fk FOREIGN KEY (customer_id) REFERENCES source3.craft_market_customers(customer_id) ON DELETE RESTRICT;