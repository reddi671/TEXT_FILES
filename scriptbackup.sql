 

--we have to change the base url on the environment basis

create table warranty_backup_register (`register_id` bigint unsigned not null, `invoice_details` varchar(255), primary key(`register_id`));
create table warranty_register_image_backup(`image_id` bigint unsigned not null, `image_url` varchar(255), primary key(`image_id`) );

insert into warranty_backup_register (register_id, invoice_details) select register_id, invoice_details from warranty_registration where invoice_details is not null AND invoice_details != '';
insert into warranty_register_image_backup(image_id, image_url) select image_id, image_url from warranty_register_image where image_url is not null AND image_url != '';

update warranty_registration wr INNER JOIN warranty_backup_register wb ON wr.register_id = wb.register_id SET wr.invoice_details = CONCAT('https://d2i2t7fzvm0wq1.cloudfront.net/warranty/', wb.invoice_details); 
update warranty_register_image wi INNER JOIN warranty_register_image_backup wib ON wi.image_id = wib.image_id SET wi.image_url = CONCAT('https://d2i2t7fzvm0wq1.cloudfront.net/warranty/', wib.image_url);

drop table warranty_backup_register;
drop table warranty_register_image_backup;



create table warranty_claim_backup (`claim_id` bigint unsigned not null, `invoice_details` varchar(255), primary key(`claim_id`));
create table warranty_claim_image_backup(`image_id` bigint unsigned not null, `image_url` varchar(255), primary key(`image_id`) );

insert into warranty_claim_backup (claim_id, invoice_details) select claim_id, invoice_details from warranty_claim_and_support where invoice_details is not null AND invoice_details != '';
insert into warranty_claim_image_backup(image_id, image_url) select image_id, image_url from warranty_claim_and_support_image where image_url is not null AND image_url != '';

update warranty_claim_and_support wc INNER JOIN warranty_claim_backup wcb ON wc.claim_id = wcb.claim_id SET wc.invoice_details = CONCAT('https://d2i2t7fzvm0wq1.cloudfront.net/warranty/', wcb.invoice_details); 
update warranty_claim_and_support_image wci INNER JOIN warranty_claim_image_backup wcib ON wci.image_id = wcib.image_id SET wci.image_url = CONCAT('https://d2i2t7fzvm0wq1.cloudfront.net/warranty/', wcib.image_url);

drop table warranty_claim_backup;
drop table warranty_claim_image_backup;

highlights API:
-------------------

update product_highlights set image_1 = CONCAT('https://www.beatxp.com/highlights/',image_1) where image_1 !="" OR image_1 != NULL;

--review script 
--we have to change the base url on the environment basis

create table review_image_backup(`image_id` bigint unsigned not null, `image_url` varchar(255), primary key(`image_id`));

insert into review_image_backup(image_id, image_url) select image_id, image_url from review_image where image_url is not null and image_url !='';

update review_image ri INNER JOIN review_image_backup rib ON ri.image_id = rib.image_id SET ri.image_url = CONCAT('https://d2i2t7fzvm0wq1.cloudfront.net/reviews/', rib.image_url); 

drop table review_image_backup;

---product sql---
SELECT * FROM (SELECT ce.entity_id,ea.attribute_id,ea.backend_type,ea.attribute_code,CASE ea.backend_type   WHEN 'varchar' THEN ce_varchar.value   WHEN 'int' THEN ce_int.value
WHEN 'text' THEN ce_text.value WHEN 'decimal' THEN ce_decimal.value WHEN 'datetime' THEN ce_datetime.value  ELSE ea.backend_type END AS value,ea.is_required AS required FROM catalog_product_entity AS ce 
LEFT JOIN eav_attribute AS ea  ON ce.attribute_set_id = ea.entity_type_id LEFT JOIN catalog_product_entity_varchar AS ce_varchar 
  ON ce.entity_id = ce_varchar.entity_id  AND ea.attribute_id = ce_varchar.attribute_id  AND ea.backend_type = 'varchar' 
LEFT JOIN catalog_product_entity_int AS ce_int  ON ce.entity_id = ce_int.entity_id  AND ea.attribute_id = ce_int.attribute_id 
 AND ea.backend_type = 'int' LEFT JOIN catalog_product_entity_text AS ce_text  ON ce.entity_id = ce_text.entity_id 
 AND ea.attribute_id = ce_text.attribute_id  AND ea.backend_type = 'text' LEFT JOIN catalog_product_entity_decimal AS ce_decimal 
 ON ce.entity_id = ce_decimal.entity_id  AND ea.attribute_id = ce_decimal.attribute_id  AND ea.backend_type = 'decimal' 
LEFT JOIN catalog_product_entity_datetime AS ce_datetime  ON ce.entity_id = ce_datetime.entity_id  AND ea.attribute_id = ce_datetime.attribute_id 
 AND ea.backend_type = 'datetime' WHERE ce.entity_id = 76) as tab;




select
   p.entity_id  as entity_id,if(pp.level = 1, n.value, concat_ws (' / ', pn.value, n.value)) as name, date(p.created_at) as created_at from
   catalog_category_entity p -- name
   left join catalog_category_entity_varchar n on
      p.entity_id = n.entity_id and n.attribute_id = 45   -- status
   left join catalog_category_entity_int s on p.entity_id = s.entity_id and s.attribute_id = 42 and s.store_id = 0
   -- parent
   left join catalog_category_entity pp on p.parent_id = pp.entity_id
   -- parent name
   left join catalog_category_entity_varchar pn on
      pp.entity_id = pn.entity_id and pn.attribute_id = 45 and
      pn.store_id = 0

where s.value = 1 and status is active p.level >= 2 order by 2;





 select * from (select cce.entity_id, cce.children_count, ea.attribute_id, ea.backend_type, ea.attribute_code,
  CASE ea.backend_type WHEN 'varchar' THEN ccv.value WHEN 'int' THEN cci.value  WHEN 'decimal' THEN ccd.value WHEN 'text' THEN cct.value  
  WHEN 'datetime' THEN ccdt.value ELSE ea.backend_type END as value FROM catalog_category_entity as cce
  LEFT JOIN eav_attribute as ea ON cce.attribute_set_id = ea.entity_type_id LEFT JOIN catalog_category_entity_varchar as ccv
  ON cce.entity_id = ccv.entity_id AND ea.attribute_id = ccv.attribute_id AND ea.backend_type='varchar'
  LEFT JOIN catalog_category_entity_int cci ON cce.entity_id = cci.entity_id AND cci.attribute_id = ea.attribute_id AND ea.backend_type = 'int' 
  LEFT JOIN catalog_category_entity_text cct ON cce.entity_id = cct.entity_id AND cct.attribute_id = ea.attribute_id AND ea.backend_type = 'text'
  LEFT JOIN catalog_category_entity_datetime ccdt ON cce.entity_id = ccdt.entity_id AND ccdt.attribute_id = ea.attribute_id AND ea.backend_type = 'datetime'
   LEFT JOIN catalog_category_entity_decimal ccd ON cce.entity_id = ccd.entity_id AND ccd.attribute_id = ea.attribute_id AND ea.backend_type = 'decimal'
  where cce.entity_id =6)as tab;





 SELECT 
  e.entity_id AS product_id
  , e.type_id AS product_type
  , e.sku,
  (
    SELECT
      GROUP_CONCAT(DISTINCT(cv.value))
    FROM 
      catalog_category_entity_varchar AS cv, catalog_category_product AS at_category_id 
    WHERE
      at_category_id.category_id = cv.entity_id
      AND (at_category_id.product_id = e.entity_id) 
      AND cv.attribute_id = 41 and cv.store_id = 0
  ) AS category_name 
FROM catalog_product_entity AS e;



select cce.entity_id, ccv.attribute_id, if(ccv.attribute_id = 45, ccv.value,"") as name, if(ccv.attribute_id = 119, ccv.value,"") as url, if(ccv.attribute_id = 48, ccv.value,"") as image ,
 if(cci.attribute_id = 69, cci.value,"") as include_in_menu,  if(cci.attribute_id = 46, cci.value,"") as status from catalog_category_entity cce  join catalog_category_entity_varchar ccv on 
cce.entity_id = ccv.entity_id  and ccv.attribute_id in(45,119,48)  join catalog_category_entity_int cci on cce.entity_id = cci.entity_id and cci.attribute_id in(46,69)  where cce.entity_id = 40;


select * from catalog_category_entity cce  join catalog_category_entity_varchar ccv on 
cce.entity_id = ccv.entity_id  and ccv.attribute_id in(45,119,48)  join catalog_category_entity_int cci on cce.entity_id = cci.entity_id and cci.attribute_id in(46,69)  where cce.entity_id = 40;


select * from eav_attribute ev, catalog_category_entity cce  join catalog_category_entity_varchar ccv on 
cce.entity_id = ccv.entity_id  and ev.attribute_id = ccv.attribute_id  join catalog_category_entity_int cci on cce.entity_id = cci.entity_id and ev.attribute_id = cci.attribute_id;  where  AND ev.attribute_id = cci.attribute_id;



select * from catalog_category_entity cce join eav_attribute ev on ev.entity_type_id = cce.attribute_set_id  Join catalog_category_entity_varchar ccv on ccv.entity_id = cce.entity_id  and ccv.attribute_id = ev.attribute_id
join catalog_category_entity_int cci on cce.entity_id = cci.entity_id and cci.attribute_id = ev.attribute_id;



SELECT DISTINCT cc.entity_id as id, cc.value as path, cc1.value as name    
  FROM catalog_category_entity_varchar cc    
  JOIN catalog_category_entity_varchar cc1 ON cc.entity_id=cc1.entity_id    
  JOIN eav_entity_type ee ON cc.entity_type_id=ee.entity_type_id
  JOIN catalog_category_entity cce ON cc.entity_id=cce.entity_id
  WHERE cc.attribute_id = '57' AND cc1.attribute_id = '41' AND ee.entity_model = 'catalog/category';

  SELECT DISTINCT cc.entity_id as id, cc.value as path, cc1.value as name    
FROM 
    catalog_category_entity_varchar cc    
    JOIN catalog_category_entity_varchar cc1 ON cc.entity_id=cc1.entity_id    
    JOIN catalog_category_entity cce ON cc.entity_id=cce.entity_id
 WHERE 
    cc.attribute_id = '57' AND 
    cc1.attribute_id = '41' ; 