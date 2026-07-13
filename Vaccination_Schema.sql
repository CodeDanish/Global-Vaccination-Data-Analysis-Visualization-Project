-- ============================================================================
-- 1. DATABASE CREATION & SETUP
-- ============================================================================
CREATE DATABASE IF NOT EXISTS global_health_db;
USE global_health_db;

-- ============================================================================
-- 2. DIMENSION TABLES (Lookup Context Tables)
-- ============================================================================

-- Master Country Dimension
CREATE TABLE IF NOT EXISTS dim_countries (
    country_code VARCHAR(10) NOT NULL,              -- Maps to "Code" / "ISO_3_Code" [cite: 110, 123, 135, 144, 154]
    country_name VARCHAR(150) NOT NULL,             -- Maps to "Name" / "Country Name" [cite: 111, 125, 136, 145, 155]
    who_region VARCHAR(100) DEFAULT NULL,           -- Maps to "Who Region" [cite: 147, 156]
    PRIMARY KEY (country_code)
);

-- Disease Metadata Dimension
CREATE TABLE IF NOT EXISTS dim_diseases (
    disease_code VARCHAR(50) NOT NULL,              -- Maps to "Disease" short name [cite: 127, 138]
    disease_description VARCHAR(255) NOT NULL,      -- Maps to "Disease description" [cite: 128, 139]
    PRIMARY KEY (disease_code)
);

-- Vaccine/Antigen Metadata Dimension (Acts as dim_vaccine)
CREATE TABLE IF NOT EXISTS dim_antigens (
    antigen_code VARCHAR(50) NOT NULL,              -- Maps to "Antigen" / "Vaccine code" [cite: 113, 158]
    antigen_description VARCHAR(255) NOT NULL,      -- Maps to "Antigen_description" / "Vaccine description" [cite: 114, 159]
    PRIMARY KEY (antigen_code)
);


-- ============================================================================
-- 3. FACT TABLES (Quantitative Analytical Tables)
-- ============================================================================

-- Fact Table 1: Vaccine Coverage Metrics
CREATE TABLE IF NOT EXISTS fact_vaccine_coverage (
    fact_cov_id INT AUTO_INCREMENT,
    country_code VARCHAR(10) NOT NULL,
    year INT NOT NULL,                              -- Maps to "Year" [cite: 112]
    antigen_code VARCHAR(50) NOT NULL,
    coverage_category VARCHAR(100) DEFAULT NULL,    -- Maps to "Coverage_category" [cite: 116]
    target_number INT DEFAULT NULL,                 -- Maps to "Target number" [cite: 117]
    doses INT DEFAULT NULL,                         -- Maps to "Dodge" / Doses administered [cite: 118]
    coverage DECIMAL(5, 2) DEFAULT NULL,            -- Maps to "Coverage" percentage [cite: 119]
    PRIMARY KEY (fact_cov_id),
    
    -- Relationships and Integrity Safeguards
    FOREIGN KEY (country_code) REFERENCES dim_countries(country_code) ON DELETE CASCADE,
    FOREIGN KEY (antigen_code) REFERENCES dim_antigens(antigen_code) ON DELETE CASCADE
);

-- Fact Table 2: Disease Incidence Rates
CREATE TABLE IF NOT EXISTS fact_incidence_rates (
    fact_inc_id INT AUTO_INCREMENT,
    country_code VARCHAR(10) NOT NULL,
    year INT NOT NULL,                              -- Maps to "Year" [cite: 126]
    disease_code VARCHAR(50) NOT NULL,
    denominator VARCHAR(150) DEFAULT NULL,          -- Maps to "Denominator" [cite: 129]
    incidence_rate DECIMAL(12, 4) DEFAULT NULL,     -- Maps to "Incidence rate" metric [cite: 130]
    PRIMARY KEY (fact_inc_id),
    
    -- Relationships and Integrity Safeguards
    FOREIGN KEY (country_code) REFERENCES dim_countries(country_code) ON DELETE CASCADE,
    FOREIGN KEY (disease_code) REFERENCES dim_diseases(disease_code) ON DELETE CASCADE
);

-- Fact Table 3: Total Reported Infection Cases
CREATE TABLE IF NOT EXISTS fact_reported_cases (
    fact_cases_id INT AUTO_INCREMENT,
    country_code VARCHAR(10) NOT NULL,
    year INT NOT NULL,                              -- Maps to "Year" [cite: 137]
    disease_code VARCHAR(50) NOT NULL,
    cases INT DEFAULT NULL,                         -- Maps to "Cases" raw count [cite: 140]
    PRIMARY KEY (fact_cases_id),
    
    -- Relationships and Integrity Safeguards
    FOREIGN KEY (country_code) REFERENCES dim_countries(country_code) ON DELETE CASCADE,
    FOREIGN KEY (disease_code) REFERENCES dim_diseases(disease_code) ON DELETE CASCADE
);