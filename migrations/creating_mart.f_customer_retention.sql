create table mart.f_customer_retention (
id serial primary key,
new_customers_count int,
returning_customers_count int,
refunded_customers_count int,
period_name varchar(10),
period_id int,
item_id int,
new_customers_revenue numeric(8,2),
returning_customers_revenue numeric(8,2),
customers_refunded int
);
COMMENT ON column mart.f_customer_retention.id is 'Уникальный код таблицы';
COMMENT ON column mart.f_customer_retention.new_customers_count is 'Кол-во новых клиентов (тех, которые сделали только один 
заказ за рассматриваемый промежуток времени)';
COMMENT ON column mart.f_customer_retention.returning_customers_count is 'Кол-во вернувшихся клиентовы';
COMMENT ON column mart.f_customer_retention.refunded_customers_count is 'Кол-во клиентов, оформивших возврат за 
рассматриваемый промежуток времени';
COMMENT ON column mart.f_customer_retention.period_name is 'Название периода';
COMMENT ON column mart.f_customer_retention.period_id is 'Идентификатор периода (номер недели или номер месяца)';
COMMENT ON column mart.f_customer_retention.item_id is 'Идентификатор категории товара';
COMMENT ON column mart.f_customer_retention.new_customers_revenue is 'Доход с новых клиентов';
COMMENT ON column mart.f_customer_retention.returning_customers_revenue is 'Доход с вернувшихся клиентов';
COMMENT ON column mart.f_customer_retention.customers_refunded is 'Количество возвратов клиентов';