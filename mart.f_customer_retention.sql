insert into mart.f_customer_retention (new_customers_count, returning_customers_count, refunded_customers_count,
    period_name, period_id, item_id, new_customers_revenue, returning_customers_revenue, customers_refunded)
with nc as (select uol.customer_id,
    extract(week from uol.date_time::date) as period_id
    from staging.user_order_log uol
    group by uol.customer_id, extract(week from uol.date_time::date)
    having count(uol.item_id) = 1),
rc as (select uol.customer_id,
    extract(week from uol.date_time::date) as period_id
    from staging.user_order_log uol
    group by uol.customer_id, extract(week from uol.date_time::date)
    having count(uol.item_id) > 1),
refc as (select distinct uol.customer_id,
    extract(week from uol.date_time::date) as period_id
    from staging.user_order_log uol
    where uol.status = 'refunded'),
new_ac as (select extract(week from uol.date_time::date) as period_id,
    uol.item_id,
    sum(uol.payment_amount) new_customers_revenue,
    count(distinct uol.customer_id) new_customers_count
    from staging.user_order_log uol
        inner join nc on uol.customer_id = nc.customer_id
        and extract(week from uol.date_time::date) = nc.period_id
        group by extract(week from uol.date_time::date), uol.item_id
    ),
ret_ac as (select extract(week from uol.date_time::date) as period_id,
    uol.item_id,
    sum(uol.payment_amount) returning_customers_revenue,
    count(distinct uol.customer_id) returning_customers_count
    from staging.user_order_log uol
        inner join rc on uol.customer_id = rc.customer_id
        and extract(week from uol.date_time::date) = rc.period_id
        group by extract(week from uol.date_time::date), uol.item_id
    )
select new_ac.new_customers_count,
    ret_ac.returning_customers_count,
    count(distinct uol.customer_id) refunded_customers_count,
    'weekly' as period_name,
    extract(week from uol.date_time::date) as period_id,
    uol.item_id,
    new_ac.new_customers_revenue,
    ret_ac.returning_customers_revenue,
    count(uol.customer_id) customers_refunded    
    from staging.user_order_log uol
        left join new_ac on uol.item_id = new_ac.item_id
        and extract(week from uol.date_time::date) = new_ac.period_id
        left join ret_ac on uol.item_id = ret_ac.item_id
        and extract(week from uol.date_time::date) = ret_ac.period_id
        group by extract(week from uol.date_time::date),
        uol.item_id,
        new_ac.new_customers_revenue,
        new_ac.new_customers_count,
        ret_ac.returning_customers_revenue,
        ret_ac.returning_customers_count
    having extract(week from uol.date_time::date) = extract(week from '{{ds}}'::date);