INSERT INTO `addon_account` (name, label, shared) VALUES 
    ('society_starbucks','starbucks',1);

INSERT INTO `datastore` (name, label, shared) VALUES 
    ('society_starbucks','starbucks',1);

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
    ('society_starbucks', 'starbucks', 1);

INSERT INTO `jobs` (`name`, `label`) VALUES
    ('starbucks', 'starbucks');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
    ('starbucks', 0, 'recrue', 'Intérimaire', 200, 'null', 'null'),
    ('starbucks', 1, 'cdisenior', 'Chef', 600, 'null', 'null'),
    ('starbucks', 2, 'boss', 'Patron', 1000, 'null', 'null');

INSERT INTO `items` (`name`, `label`) VALUES
    ('graimedecoffe', 'graimedecafé'),
	('coffe', 'Café');
