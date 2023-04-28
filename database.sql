CREATE SEQUENCE local_store_id_seq START 1;

CREATE TABLE locale_store
(
    id          BIGINT  DEFAULT nextval('local_store_id_seq') PRIMARY KEY,
    size_store         BIGINT   DEFAULT 20  NOT NULL,
    place_store varchar(30)         NOT NULL,
    polka      BIGINT   DEFAULT 1,
    posizion  BIGINT   DEFAULT 1,
    current_size  INTEGER    DEFAULT 0  NOT NULL,
    min_size BIGINT DEFAULT 12
);



CREATE SEQUENCE storage_area_id_seq START 1;

CREATE TABLE storage_area
(
    id            BIGINT  DEFAULT nextval('storage_area_id_seq') PRIMARY KEY,
    place_storage varchar(30) NOT NULL,
    size_storage  INTEGER DEFAULT 5000
);

CREATE SEQUENCE order_item_id_seq START 1;

CREATE TABLE order_item
(
    id              BIGINT                      DEFAULT nextval('order_item_id_seq') PRIMARY KEY,
    status          bool                                                  NOT NULL,
    date_dispatch   TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    count_palets    INTEGER                                               NOT NULL,
    brak            boolean                     DEFAULT false             NOT NULL,
    id_storage_area BIGINT                                                NOT NULL
);
CREATE SEQUENCE order_item_el_id_seq START 1;

CREATE TABLE order_item_el
(
    id              BIGINT                      DEFAULT nextval('order_item_el_id_seq') PRIMARY KEY,
    count_product  INTEGER                     NOT NULL,
	unit_price  INTEGER                     NOT NULL,
	id_product   BIGINT                                                NOT NULL,
    id_order_item   BIGINT                                                NOT NULL
);
CREATE SEQUENCE inventory_id_seq START 1;

CREATE TABLE inventory
(
    id              BIGINT                      DEFAULT nextval('inventory_id_seq') PRIMARY KEY,
    date_inventory   TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    count_product    INTEGER                                               NOT NULL,
    size_product        INTEGER                                             NOT NULL,
	id_locale_store   BIGINT                                                NOT NULL
);

CREATE SEQUENCE product_id_seq START 1;

CREATE TABLE product
(
    id            BIGINT DEFAULT nextval('product_id_seq') PRIMARY KEY,
    name_product  varchar(30)                 NOT NULL,
    count_product  INTEGER                     NOT NULL,
    godnota_start TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    godnota_end   TIMESTAMP WITHOUT TIME ZONE NULL,
    id_order      BIGINT                      NOT NULL,
    id_locale_store   BIGINT                      NOT NULL,
    name_category  varchar(30)                 NOT NULL,
	size_product  INTEGER                     NOT NULL
);

CREATE SEQUENCE write_downs_id_seq START 1;

CREATE TABLE write_downs
(
    id             BIGINT                      DEFAULT nextval('write_downs_id_seq') PRIMARY KEY,
    id_product     BIGINT                                                NOT NULL,
    date_writedown TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    quantity       INTEGER                                               NOT NULL
);

CREATE SEQUENCE history_status_order_id_seq START 1;

CREATE TABLE history_status_order
(
    id                BIGINT                      DEFAULT nextval('history_status_order_id_seq') PRIMARY KEY,
    last_status_order varchar(30)                                           NOT NULL,
    date_change       TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id_order          BIGINT                                                NOT NULL
);

CREATE SEQUENCE refund_id_seq START 1;

CREATE TABLE refund
(
    id          BIGINT DEFAULT nextval('refund_id_seq') PRIMARY KEY,
    reazon      varchar(30)                 NOT NULL,
    create_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    id_order    BIGINT                      NOT NULL
);

CREATE SEQUENCE notify_id_seq START 1;

CREATE TABLE notify
(
    id           BIGINT DEFAULT nextval('notify_id_seq') PRIMARY KEY,
    date_notify       TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reazon      varchar(90)                 NOT NULL
);

ALTER TABLE order_item
    ADD FOREIGN KEY (id_storage_area) REFERENCES storage_area (id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE order_item_el
    ADD FOREIGN KEY (id_order_item) REFERENCES order_item (id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE order_item_el
    ADD FOREIGN KEY (id_product) REFERENCES product (id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE product
    ADD FOREIGN KEY (id_locale_store) REFERENCES locale_store (id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE write_downs
    ADD FOREIGN KEY (id_product) REFERENCES product (id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE history_status_order
    ADD FOREIGN KEY (id_order) REFERENCES order_item (id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE refund
    ADD FOREIGN KEY (id_order) REFERENCES order_item (id)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inventory
    ADD FOREIGN KEY (id_locale_store) REFERENCES locale_store (id)
        ON UPDATE CASCADE ON DELETE CASCADE;
