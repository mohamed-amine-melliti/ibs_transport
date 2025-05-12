-- Clients Table
CREATE TABLE clients (
  id_client TEXT PRIMARY KEY,
  societe TEXT,
  nom TEXT,
  prenom TEXT,
  civilite TEXT,
  mail TEXT,
  tel TEXT,
  ville TEXT,
  numrue TEXT,
  adresse TEXT,
  adresse_infplus TEXT,
  code TEXT,
  code2 TEXT,
  interphone TEXT,
  bat TEXT,
  escalier TEXT,
  etage TEXT,
  porte TEXT
);

-- Restaurants Table
CREATE TABLE restaurants (
  id_site BIGINT PRIMARY KEY,
  enseigne TEXT,
  raison_social TEXT,
  tel TEXT,
  adresse TEXT,
  cp TEXT,
  ville TEXT,
  n_siret TEXT,
  paye TEXT,
  code_ape TEXT,
  num_cnil TEXT,
  n_tva TEXT
);

-- Orders Table
CREATE TABLE orders (
  num_cmd TEXT PRIMARY KEY,
  id_site BIGINT REFERENCES restaurants(id_site),
  id_client TEXT REFERENCES clients(id_client),
  type_cde TEXT,
  etat_cmde TEXT,
  date_cde TEXT,
  heure_cde TEXT,
  date_liv TEXT,
  heure_liv TEXT,
  totalht DOUBLE PRECISION,
  totalttc TEXT,
  reduction BIGINT,
  totalttc_net TEXT,
  frais_livraison BIGINT,
  frais_livraison_tva BIGINT,
  frais_gestion BIGINT,
  frais_gestion_tva BIGINT,
  tottva1 TEXT,
  tottva2 BIGINT,
  tottva3 TEXT,
  tva1 BIGINT,
  tva2 BIGINT,
  tva3 BIGINT,
  httva1 TEXT,
  httva2 BIGINT,
  httva3 TEXT,
  ttctva1 DOUBLE PRECISION,
  ttctva2 BIGINT,
  ttctva3 BIGINT,
  note_cmde TEXT,
  modreg_prev TEXT,
  modreg_pel TEXT,
  codepe TEXT
);

-- Products Table
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  num_cmd TEXT REFERENCES orders(num_cmd),
  ref TEXT,
  nom_produit TEXT,
  nom_taille TEXT,
  nom_famille TEXT,
  id_taille TEXT,
  id_famille TEXT,
  qte INT,
  prix_unit_ttc TEXT,
  prix_tot_ttc DOUBLE PRECISION,
  tva_produit INT,
  menu INT,
  produit_menu INT
);


-- Insert into clients
INSERT INTO clients VALUES (
  '7', 'TEST', 'RIMEH', 'SALAH', 'MME', 'RIMEH.DESCLICK@GMAIL.COM', '0123456789',
  'CACHAN 94230', '', 'RUE TEST', NULL, '', '', '', '', '', ''
);

-- Insert into restaurants
INSERT INTO restaurants VALUES (
  2421, 'PLATINIUM DEMO V2', NULL, '0101010101', '3 RUE LECH WALESA',
  '94 270', 'LE KREMLIN-BICêTRE', '111111', 'FRANCE', 'AAB', '125', '10'
);

-- Insert into orders
INSERT INTO orders VALUES (
  '1', 2421, '7', '2', '0', '20250512', '1759', '20221220', '1210',
  28.1818181818182, '31.00', 0, '31.00', 0, 20, 0, 20, '2.8181818181818', 0,
  '0', 10, 0, 0, '28.181818181818', 0, '0', 30.999999999999797, 0, 0,
  '', 'ESP', NULL, 'A'
);

-- Insert into products
INSERT INTO products (num_cmd, ref, nom_produit, nom_taille, nom_famille, id_taille, id_famille, qte, prix_unit_ttc, prix_tot_ttc, tva_produit, menu, produit_menu) VALUES
('1', '129', 'TAGLIATELLES BOLOGNAISE', NULL, 'PATES', NULL, '64', 1, '8.00', 8, 10, 0, 0),
('1', '78', 'REINE', 'MEGA', 'PIZZAS', '66', '3', 1, '17.00', 17, 10, 0, 0),
('1', 'i', 'SUPP SAUCE BARBECUE', NULL, 'COMPOSANTS', NULL, NULL, 1, '2', 2, 10, 0, 0),
('1', 'i', 'SUPP THON', NULL, 'COMPOSANTS', NULL, NULL, 1, '2', 2, 10, 0, 0),
('1', 'i', 'SUPP OLIVES', NULL, 'COMPOSANTS', NULL, NULL, 1, '0', 0, 10, 0, 0),
('1', 'i', 'SUPP GORGONZOLA', NULL, 'COMPOSANTS', NULL, NULL, 1, '2', 2, 10, 0, 0);