-- ========================================
-- Organization Table
-- ========================================
CREATE TABLE organization (
	organization_id SERIAL PRIMARY KEY,
	name VARCHAR(150) NOT NULL,
	description TEXT NOT NULL,
	contact_email VARCHAR(255) NOT NULL,
	logo_filename VARCHAR(255) NOT NULL
);

-- ========================================
-- Insert sample data: Organizations
-- ========================================
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

-- ========================================
-- Projects Table
-- ========================================
CREATE TABLE project (
	project_id SERIAL PRIMARY KEY,
	organization_id INTEGER NOT NULL,
	title VARCHAR(150) NOT NULL,
	description TEXT NOT NULL,
	location VARCHAR(255) NOT NULL,
	date DATE NOT NULL,
	FOREIGN KEY (organization_id) REFERENCES organization(organization_id)
);

-- ========================================
-- Insert sample data: PROJECTS
-- ========================================
INSERT INTO project (organization_id, title, description, location, date) 
VALUES
-- Projects for BrightFuture Builders (organization_id = 1)
(1, 'Community Center Roof Repair', 'Repairing the roof of the downtown community center using sustainable materials.', 'Downtown Community Hub', '2026-11-05'),
(1, 'Sustainable Park Bench Installation', 'Building and installing recycled plastic park benches along the riverside walking path.', 'Riverside Park', '2026-11-12'),
(1, 'Eco-Friendly Library Ramp', 'Constructing an ADA-compliant wooden accessibility ramp for the public library.', 'Westside Public Library', '2026-11-20'),
(1, 'Solar Panel Setup for Shelter', 'Installing a small-scale solar power system to lower energy costs for the animal shelter.', 'Hope Animal Shelter', '2026-12-04'),
(1, 'Neighborhood Rain Garden Build', 'Creating a rain garden infrastructure to manage runoff and beautify the neighborhood plaza.', 'Oak Street Plaza', '2026-12-15'),

-- Projects for GreenHarvest Growers (organization_id = 2)
(2, 'Urban Rooftop Farm Setup', 'Establishing raised garden beds on the high school roof for agricultural education.', 'Central High School', '2026-11-08'),
(2, 'Community Composting Workshop', 'Hosting a hands-on workshop teaching residents how to set up and maintain backyard compost bins.', 'Northside Community Center', '2026-11-15'),
(2, 'Hydroponics Lab Installation', 'Setting up indoor vertical hydroponic systems for year-round greens production.', 'Youth Development Club', '2026-12-01'),
(2, 'Neighborhood Seed Planting Day', 'Distributing heirloom seeds and planting community flower and vegetable borders.', 'Eastside Park', '2026-12-10'),
(2, 'Fall Harvest Food Drive Prep', 'Organizing and harvesting produce beds to donate directly to local food pantries.', 'GreenHarvest Main Facility', '2027-01-10'),

-- Projects for UnityServe Volunteers (organization_id = 3)
(3, 'Food Bank Packaging Drive', 'Sorting and packing bulk food donations into family-sized boxes for distribution.', 'Regional Food Bank', '2026-11-10'),
(3, 'Senior Care Tech Assistance', 'Helping elderly residents set up communication devices to connect with family members.', 'Sunset Retirement Village', '2026-11-22'),
(3, 'After-School Tutoring Outreach', 'Providing one-on-one homework help and mentoring for elementary school students.', 'Southside Elementary', '2026-12-05'),
(3, 'Winter Coat Distribution Prep', 'Sorting, cleaning, and cataloging donated winter coats ahead of the cold season.', 'UnityServe Center', '2026-12-18'),
(3, 'Disaster Relief Kit Assembly', 'Assembling emergency preparedness hygiene and supply kits for local outreach.', 'Emergency Response Warehouse', '2027-01-15');

-- ========================================
-- Categories Table
-- ========================================
CREATE TABLE category (
	category_id SERIAL PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL UNIQUE
);

-- ========================================
-- Project Categories (Junction Table)
-- ========================================
CREATE TABLE project_category (
	project_id INTEGER NOT NULL,
	category_id INTEGER NOT NULL,
	PRIMARY KEY (project_id, category_id),
	FOREIGN KEY (project_id) REFERENCES project(project_id),
	FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- ========================================
-- Insert sample data: Categories
-- ========================================
INSERT INTO category (category_name) 
VALUES 
('Environment'),
('Community Service'),
('Education'),
('Food Assistance');

-- ========================================
-- Insert sample data: Project Categories
-- ========================================
INSERT INTO project_category (project_id, category_id) 
VALUES
-- Projects for BrightFuture Builders (organization_id = 1)
(1, 2),  -- Community Center Roof Repair -> Community Service
(2, 1),  -- Sustainable Park Bench Installation -> Environment
(2, 2),  -- Sustainable Park Bench Installation -> Community Service
(3, 2),  -- Eco-Friendly Library Ramp -> Community Service
(4, 1),  -- Solar Panel Setup for Shelter -> Environment
(5, 1),  -- Neighborhood Rain Garden Build -> Environment

-- Projects for GreenHarvest Growers (organization_id = 2)
(6, 1),  -- Urban Rooftop Farm Setup -> Environment
(6, 3),  -- Urban Rooftop Farm Setup -> Education
(7, 1),  -- Community Composting Workshop -> Environment
(7, 3),  -- Community Composting Workshop -> Education
(8, 1),  -- Hydroponics Lab Installation -> Environment
(8, 3),  -- Hydroponics Lab Installation -> Education
(9, 1),  -- Neighborhood Seed Planting Day -> Environment
(10, 4), -- Fall Harvest Food Drive Prep -> Food Assistance

-- Projects for UnityServe Volunteers (organization_id = 3)
(11, 4), -- Food Bank Packaging Drive -> Food Assistance
(11, 2), -- Food Bank Packaging Drive -> Community Service
(12, 2), -- Senior Care Tech Assistance -> Community Service
(12, 3), -- Senior Care Tech Assistance -> Education
(13, 3), -- After-School Tutoring Outreach -> Education
(14, 2), -- Winter Coat Distribution Prep -> Community Service
(15, 2); -- Disaster Relief Kit Assembly -> Community Service