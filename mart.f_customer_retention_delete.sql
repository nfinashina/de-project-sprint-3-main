delete from mart.f_customer_retention
where period_id = extract(week from '{{ds}}'::date)