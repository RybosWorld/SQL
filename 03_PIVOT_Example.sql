/* test2 22*/
DECLARE @strContractId AS varchar(25)
SET @strContractId = 143

SELECT 
	ContractId,
	[4] AS '4.0%',
	[2] AS '2.0%',
	[1] AS '1.0%',
	[0.4] AS '0.4%',
	[0.2] AS '0.2%',
	[0.1] AS '0.1%'
FROM 
	(
		SELECT 
			@strContractId AS ContractId,
			CAST(RANK() OVER (ORDER BY MAX(LossSum) DESC) AS float)/100 as [EP %],
			MAX(LossSum) AS YearLossMax
		FROM 
			(	
				SELECT DISTINCT
					YearId, 
					ModelCode, 
					EventId,
					SUM(GrossLoss) AS LossSum
				FROM 
					t2_LOSS_ByContractGeo AS loss 
				INNER JOIN t2_LOSS_DimContract AS dim 
					ON loss.ContractSID = dim.ContractSID
				WHERE 
					CatalogTypeCode = 'STC'
					AND ContractId = @strContractId
				GROUP BY 
					YearId,
					ModelCode,
					EventId   
			) AS Step1
		GROUP BY 
			YearId
	) AS Step2
PIVOT (MAX(YearLossMax) FOR [EP %] IN ([4], [2], [1], [0.4], [0.2], [0.1])) AS P
