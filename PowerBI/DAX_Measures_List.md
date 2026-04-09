
**Total customers**
Total Customers = COUNT(churnanalysis[user_id])

**Churn rate %**
Churn rate % = DIVIDE([Churned Customers],[Total Customers],0)

**Revenue Lost**
Revenue Lost = CALCULATE(SUM(churnanalysis[monthly_fee]),churnanalysis[Churn_flag] = 1 )

**Total Spend**
Total Spend = Sum(churnanalysis[monthly_fee])

**Revenue At Risk**
Revenue At Risk = CALCULATE(SUM(churnanalysis[monthly_fee]),churnanalysis[Risk Segment] = "High Risk")

**Churned Customers**
Churned Customers = SUM(churnanalysis[Churn_flag])

**Average Rate per User**
ARPU = AVERAGE(churnanalysis[monthly_fee])
