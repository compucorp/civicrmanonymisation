UPDATE civicrm_hrjob_pay SET pay_amount = 50000, pay_annualized_est=100000;
UPDATE civicrm_hrjobcontract_pay SET pay_amount = 50000, pay_annualized_est=100000;
UPDATE civicrm_hrjobcontract_details SET position = CONCAT('Anonymous_',SUBSTRING(md5(position),1,6));
UPDATE civicrm_hrjobcontract_details SET title = CONCAT('Anonymous_',SUBSTRING(md5(title),1,6));
UPDATE civicrm_hrjob_role SET title = CONCAT('Anonymous_',SUBSTRING(md5(title),1,6));
UPDATE civicrm_hrjobcontract_role SET title = CONCAT('Anonymous_',SUBSTRING(md5(title),1,6));
UPDATE civicrm_hrjobroles SET title = CONCAT('Anonymous_',SUBSTRING(md5(title),1,6));