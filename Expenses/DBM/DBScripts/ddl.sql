DROP TABLE IF EXISTS category;
CREATE TABLE category (
    name text NOT NULL,
    times int NOT NULL,
    notes text NULL
);

DROP TABLE IF EXISTS expenses;
CREATE TABLE expenses (
    amount int NOT NULL,
    record_date text NOT NULL,
    expense_date text NOT NULL,
    cat_id integer NOT NULL,
    notes text NULL,
    FOREIGN KEY (cat_id) REFERENCES category (rowid)
);
