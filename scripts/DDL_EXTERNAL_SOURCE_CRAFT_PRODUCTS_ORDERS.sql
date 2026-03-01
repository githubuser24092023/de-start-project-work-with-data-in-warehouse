-- external_source.craft_products_orders definition

-- Drop table

-- DROP TABLE external_source.craft_products_orders;

CREATE TABLE external_source.craft_products_orders (
	id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	craftsman_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	craftsman_name varchar NOT NULL,
	craftsman_address varchar NOT NULL,
	craftsman_birthday date NOT NULL,
	craftsman_email varchar NOT NULL,
	product_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	product_name varchar NOT NULL,
	product_description varchar NOT NULL,
	product_type varchar NOT NULL,
	product_price int8 NOT NULL,
	order_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	order_created_date date NULL,
	order_completion_date date NULL,
	order_status varchar NOT NULL,
	customer_id int8 NOT NULL,
	CONSTRAINT external_craft_products_orders_pk PRIMARY KEY (id)
);


-- external_source.craft_products_orders foreign keys

ALTER TABLE external_source.craft_products_orders ADD CONSTRAINT external_craft_products_orders_fk FOREIGN KEY (customer_id) REFERENCES external_source.customers(customer_id) ON DELETE RESTRICT;