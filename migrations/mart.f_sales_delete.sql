delete from mart.f_sales s
where s.date_id = (select c.date_id from mart.d_calendar c
                    where c.date_actual::date = '{{ds}}');