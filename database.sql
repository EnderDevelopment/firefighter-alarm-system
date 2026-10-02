CREATE TABLE IF NOT EXISTS ff_alarms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    fire_station_id INT NOT NULL,
    alarm_time DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (player_id) REFERENCES users(identifier),
    FOREIGN KEY (fire_station_id) REFERENCES ff_fire_stations(id)
);

CREATE TABLE IF NOT EXISTS ff_fire_stations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    coords VARCHAR(100) NOT NULL,
    radius FLOAT NOT NULL
);

INSERT INTO ff_fire_stations (name, coords, radius) VALUES
('Los Santos Fire Station', '1202.3, -1465.2, 34.8', 50.0),
('Sandy Shores Fire Station', '1857.6, 3683.1, 34.2', 50.0),
('Paleto Bay Fire Station', '-449.6, 6013.3, 31.7', 50.0);