mysqldump -u root -p magento2 --single-transaction > temp.sql

******************************
to get configurable options 
*********************************
--1) TO GET ATTRIBUTES FOR CONFIG


SELECT ea.attribute_id, ea.attribute_code, ea.frontend_label as label, cpsa.product_id FROM catalog_product_super_attribute cpsa, eav_attribute ea where ea.attribute_id = cpsa.attribute_id AND product_id=45
--2) TO GET OPTIONS FOR CONFIG PRODUCT
select Distinct eo.option_id as value_index, eov.value, cpe.attribute_id from catalog_product_entity_int as cpe 
INNER JOIN eav_attribute_option as eo ON cpe.attribute_id = 137 AND cpe.attribute_id = eo.attribute_id 
AND cpe.value = eo.option_id INNER JOIN eav_attribute_option_value eov ON cpe.value = eov.option_id where cpe.entity_id in 
(select cpr.child_id from catalog_product_relation cpr where cpr.parent_id=45);



SELECT customer_address_entity.entity_id, customer_address_entity.city, customer_address_entity.street, 
customer_address_entity.region, customer_address_entity.postcode, customer_address_entity.firstname, 
customer_address_entity.lastname, customer_address_entity.address_line, customer_address_entity.address_type, 
customer_address_entity.shipping_carrier, customer_address_entity.shipping_method, 
customer_address_entity.utm_source, customer_address_entity.telephone, customer_address_entity.created_at,
customer_address_entity.email, guest_checkout_cart.name as productName, guest_checkout_cart.sku as productSku FROM customer_address_entity, guest_checkout_cart 
WHERE customer_address_entity.entity_id = guest_checkout_cart.address_id and  customer_address_entity.cart_flag = 0 
and customer_address_entity.created_at >="2023-01-01" and customer_address_entity.created_at <="2023-04-26" 
ORDER BY customer_address_entity.entity_id DESC;



--#####################  TO CHANGE THE EXISTING TEXT IN COLUMN 

1)update warranty_claim_and_support_image set image_url = replace(image_url , 'beatxp-v2-uploads.s3.ap-south-1.amazonaws.com','img.beatxp.com');

2)update warranty_claim_and_support set invoice_details = replace(invoice_details , 'beatxp-v2-uploads.s3.ap-south-1.amazonaws.com','img.beatxp.com');

3)update warranty_registration set invoice_details = replace(invoice_details , 'beatxp-v2-uploads.s3.ap-south-1.amazonaws.com','img.beatxp.com');

4)update warranty_register_image set image_url = replace(image_url , 'beatxp-v2-uploads.s3.ap-south-1.amazonaws.com','img.beatxp.com');


---### orders sql ---------

SELECT DISTINCT so.entity_id,so.increment_id, so.status,DATE_FORMAT(so.created_at, '%d %M, %Y') as created_at,so.coupon_code,
so.shipping_description,so.base_discount_amount,so.grand_total,soa.firstname,soa.lastname,soa.region,soa.street,soa.city,soa.email,
soa.telephone,soa.postcode,soa.vat_id,sop.method from sales_order so, sales_order_payment sop, sales_order_address soa 
WHERE so.entity_id = sop.parent_id AND so.entity_id = soa.parent_id AND soa.address_type ='billing' AND so.entity_id =1;

--general all
select SUM(sop.method='razorpay') as razorpay, SUM(sop.method='cashondelivery') as cashondelivery 
from sales_order_payment sop, sales_order_address soa, sales_order so 
where sop.parent_id = so.entity_id and soa.parent_id = so.entity_id  and soa.address_type = "billing"  
and so.created_at > "2023-05-03T00:00:22.716Z" and so.created_at < "2023-05-03T10:22:22.716Z";
--V1----

select count(sop.method='razorpay') as razorpay, count(sop.method='cashondelivery') as cashondelivery 
from sales_order_payment sop, sales_order_address soa, sales_order so 
where sop.parent_id = so.entity_id and soa.parent_id = so.entity_id  and soa.address_type = "billing" and soa.lastname is NULL 
and so.created_at > "2023-05-03T00:00:22.716Z" and so.created_at < "2023-05-03T10:22:22.716Z";

--V2---
select count(sop.method='razorpay') as razorpay, count(sop.method='cashondelivery') as cashondelivery 
from sales_order_payment sop, sales_order_address soa, sales_order so 
where sop.parent_id = so.entity_id and soa.parent_id = so.entity_id  and soa.address_type = "billing" 
and soa.lastname ='v2' and so.created_at > "2023-05-03T00:00:22.716Z" and so.created_at < "2023-05-03T10:22:22.716Z";


#### ORDER LIST###
SELECT COUNT(entity_id)  as count, SUM(status='canceled') as canceled_count, SUM(status='complete') as complete_count, SUM(status='processing') as processing_count, SUM(status='pending') as pending_count  FROM sales_order WHERE created_at > '2023-05-09 18:30:00' and created_at < '2023-05-10 21:52:40';

####### COD AND RAZORPAY#####
SELECT  SUM(payment_method='cashondelivery') as cod_count, SUM(payment_method='razorpay') as razorpay_count  FROM sales_order, sales_order_grid WHERE sales_order.created_at > '2023-05-09 18:30:00' AND sales_order.created_at < '2023-05-10 07:52:40' AND sales_order_grid.increment_id = sales_order.increment_id AND sales_order.status != "canceled" ;

#######REVENUE Sql####
SELECT SUM(grand_total)  as revenue FROM sales_order WHERE created_at > '2023-05-09 18:30:00' AND created_at < '2023-05-10 07:52:40'AND status != "canceled";

#######Top selling products######
select sku, name,sum(qty_ordered) qty, count(distinct order_id) as skucount from sales_order_item where WHERE created_at > '2023-05-09 18:30:00' and created_at < '2023-05-10 21:52:40' group by sku order by skucount desc limit 20;

select sum(method = 'razorpay') as razorpay_count, sum(method = 'cashondelivery') as cod_count from sales_order_payment where parent_id in ( select order_id  from sales_order_item where
created_at > '2023-05-09 18:30:00' and created_at < '2023-05-10 21:52:40' and sku = '$sku');


############ UTM LIST #####
SELECT sales_order_address.vat_id from sales_order_address, sales_order where sales_order.entity_id = sales_order_address.parent_id and sales_order.created_at > '2023-05-09 18:30:00' and sales_order.created_at < '2023-05-10 21:52:40'  and sales_order_address.address_type = "billing";


########## UTM DATA ###############
SELECT SUM(CASE WHEN soa.vat_id LIKE '%utm_source=go%' OR soa.vat_id LIKE '%utm_source=Go%' THEN 1 ELSE 0 END) as googleCount,
SUM(CASE WHEN soa.vat_id LIKE '%utm_source=Br%' THEN 1 ELSE 0 END) as youtubecount,
SUM(CASE WHEN soa.vat_id LIKE '%utm_source=ig%' THEN 1 ELSE 0 END) as instacount,
SUM(CASE WHEN soa.vat_id LIKE '%utm_source=fb%' THEN 1 ELSE 0 END) as fbcount,
SUM(CASE WHEN soa.vat_id is null OR soa.vat_id ="" THEN 1 ELSE 0 END) as websiteCount
from sales_order_address soa, sales_order where sales_order.entity_id = soa.parent_id and sales_order.created_at > '2023-01-09 18:30:00' and sales_order.created_at < '2023-05-10 21:52:40'  and soa.address_type = "billing";

####### Product search api ##########
SELECT entity_id FROM catalog_product_entity WHERE entity_id IN (
SELECT cpev.entity_id FROM catalog_product_entity_varchar cpev, catalog_product_entity_int cpei WHERE cpev.value like '%pavan%' AND cpev.attribute_id = 73 AND cpev.entity_id = cpei.entity_id AND cpei.attribute_id= 97 AND cpei.value =1) AND type_id = "simple";

###### GUEST QUOTE ORDERS ###### 
select count(*)  from quote where created_at>'2023-01-11 00:00:00' and reserved_order_id is not null and customer_is_gues
t = 1;

select reserved_order_id, customer_is_guest  from quote where created_at>'2023-01-11 00:00:00' and reserved_order_id is not null and customer_is_guest = 1;



select sop.method from sales_order_payment sop, sales_order_address soa, sales_order so where sop.parent_id = so.entity_id and soa.parent_id = so.entity_id  and soa.address_type = "billing" and soa.lastname ='v2' and so.created_at > "2023-05-03T00:00:22.716Z" and so.created_at < "2023-05-03T10:22:22.716Z";



select count(sop.method) from sales_order_payment sop, sales_order_address soa, sales_order so where sop.parent_id = so.entity_id and soa.parent_id = so.entity_id  and soa.address_type = "billing" and soa.lastname ='v2' and so.created_at > "2023-05-03T00:00:22.716Z" and so.created_at < "2023-05-03T10:22:22.716Z" group by sop.method;

select count(so.entity_id) orderCount, so.coupon_code, sum(sop.method = 'cashondelivery') cod, sum(sop.method='razorpay') razorpay,sum(
so.grand_total) total from sales_order so, sales_order_payment sop where so.entity_id = sop.parent_id and created_at >= '2023-01-01 00:00:00' and created_at <= '2023-07-05 00:00:00' group by coupon_code ;




select coupon_code, entity_id, order_id , product_id, product_name, sku from sales_order so right join  sales_order_item sot on so.entity_id = sot.order_id;


select  name, sku, product_id, sum(qty_ordered), sum(price) from sales_order_item where order_id in (select entity_id from sales_order  where status !='canceled' and coupon_code = 'SANYA20' and created_at >="2023-01:01 00:00:00"  and created_at <="2023-03-03 00:00:00");




select  name, sku, product_id, count(product_id), sum(qty_ordered) as count   from sales_order_item where order_id in (select entity_id from sales_order  where status !='canceled' and coupon_code = 'SANYA20' and created_at >="2023-01:01 00:00:00"  and created_at <="2023-03-03 00:00:00") group by product_id;


select  name, sku, product_id, count(product_id), sum(qty_ordered) as qty, sum(price)   from sales_order_item where order_id in (select entity_id from sales_order  where status !='canceled' and coupon_code is 'SANYA20' and created_at >="2023-01:01 00:00:00"  and created_at <="2023-03-03 00:00:00") group by product_id;


select entity_id from sales_order  where status !='canceled' and coupon_code = NULL and created_at >="2023-01-01 00:00:00"  and created_at <="2023-03-03 00:00:00";


@

select  name, sku, product_id, count(product_id), sum(qty_ordered) as qty, sum(price) from sales_order_item 
where order_id in (select entity_id from sales_order where status !="canceled" and coupon_code ="" and created_at >="2023-01-01 00:00:00" and created_at <="2023-03-03 00:00:00") group by product_id;


Select sales_order_address.firstname,sales_order_address.street,sales_order_address.city, sales_order_address.postcode,sales_order_address.region,sales_order_address.telephone, sales_order.customer_id, customer_entity.email  from  sales_order_address, sales_order, customer_entity where sales_order_address.parent_id = sales_order.entity_id and  customer_entity.entity_id = sales_order.customer_id and sales_order_address.address_type = 'billing' and sales_order_address.parent_id = 1;



select sales_order.entity_id, sales_order.increment_id, sales_order.shipping_amount, sales_order.discount_amount, sales_order.grand_total, sales_order.coupon_rule_name, sales_order.created_at,sales_order_payment.method from sales_order, sales_order_payment where sales_order.entity_id = 1 and sales_order.entity_id = sales_order_payment.parent_id";

//sms part

Select distinct sot.item_id, name, product_id FROM sales_order_item sot where sot.order_id = 1 and product_type IN ('simple', 'configurable','virtual', 'bundle');


SELECT * FROM `catalog_product_entity_int` WHERE `attribute_id` = ( SELECT attribute_id FROM `eav_attribute` WHERE `attribute_code` = 'visibility')AND entity_id = 48;




ALTER TABLE bitnami_magento.warranty_claim_and_support CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

