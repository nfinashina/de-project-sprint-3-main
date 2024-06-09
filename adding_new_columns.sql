alter table staging.user_order_log add column status varchar(15) not null default 'shipped';
COMMENT ON column staging.user_order_log.status is 'Статус заказа';

alter table mart.f_sales add column status varchar(15) not null default 'shipped';
COMMENT ON column mart.f_sales.status is 'Статус заказа';

    