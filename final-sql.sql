SELECT
  cast(MAIN.metro_region as string) as __metro_region__,
  cast(FORMAT("%'d",SUM(MAIN.sessions)) as string) as __sessions__,
  cast(FORMAT("%'d",SUM(MAIN.transactions)) as string) as __transactions__,
  cast(CONCAT("$", format("%'.2f",SUM(MAIN.transaction_revenue))) as string) as __transaction_revenue__,
  concat(cast(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY) as string), ' through ', cast(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY) as string)) as __datehour__
FROM ecommerce.ecommerce as MAIN,
  (SELECT SUM(transactions) as sum1 , metro_region FROM ecommerce.ecommerce WHERE date(datehour) >= DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY) GROUP BY metro_region) as SUB1
WHERE ( (MAIN.sessions >= 10) or (MAIN.transactions >= 5) ) AND (date(MAIN.datehour) >= DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY) and date(MAIN.datehour) <> CURRENT_DATE )
AND (MAIN.metro_region = SUB1.metro_region)
GROUP BY MAIN.metro_region
HAVING (SUM(MAIN.transactions) < (MAX(SUB1.sum1)))
ORDER BY SUM(MAIN.sessions) DESC, MAIN.metro_region ASC
