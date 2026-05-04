CREATE SCHEMA healthcare_reporting

GO

CREATE TABLE healthcare_reporting.patients_record
(
	recordId VARCHAR(50),
	country VARCHAR(100),
	territory_code VARCHAR(10),
	population_count BIGINT,
	batch_id VARCHAR(50),
	is_valid_record BIT,
	mark VARCHAR(100),
	regular_count INT,
	origin VARCHAR(100),
	units VARCHAR(50)
)

GO
