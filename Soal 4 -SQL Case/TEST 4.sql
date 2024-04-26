--CASE 1

select * from (
select  channelGrouping, country,  sum(totalTransactionRevenue) as  REV,   RANK() OVER(PARTITION BY channelGrouping ORDER BY sum(totalTransactionRevenue)  DESC) Rank 
from [dbo].[ecommerce-session-bigquery]  group by country, channelGrouping	)a 
where rev is not null and rank <=5  and country <> '(not set)'
order by channelGrouping desc 



--CASE 3
select v2productname,trx,net_revenue,ppn, case when refund > ppn then 'rugi' else 'untung' end as flag ,ROW_NUMBER() OVER(ORDER BY net_revenue ) RANKS , from (
select a.v2productname, revenue,trx,refund,(revenue-trx) as net_revenue , revenue*0.10 as ppn  from (
select v2productname , sum(totalTransactionRevenue) as revenue from  [dbo].[ecommerce-session-bigquery] group by v2ProductName ) a 
left join (
select v2productname , sum(transactions) as trx from  [dbo].[ecommerce-session-bigquery] group by v2ProductName ) b 
on a.v2ProductName = b.v2ProductName
left join (select v2productname , sum(cast(productRefundAmount as int)) as refund from  [dbo].[ecommerce-session-bigquery] group by v2ProductName ) c

) a order by RANKS desc