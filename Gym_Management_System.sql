DROP TABLE attendance CASCADE CONSTRAINTS;
DROP TABLE class_enrollment CASCADE CONSTRAINTS;
DROP TABLE payment CASCADE CONSTRAINTS;
DROP TABLE gym_class CASCADE CONSTRAINTS;
DROP TABLE member CASCADE CONSTRAINTS;
DROP TABLE trainer CASCADE CONSTRAINTS;
DROP TABLE membership_plan CASCADE CONSTRAINTS;

CREATE TABLE membership_plan (
    plan_id         NUMBER(3)      PRIMARY KEY,
    plan_name       VARCHAR2(30)   NOT NULL UNIQUE,
    duration_months NUMBER(2)      NOT NULL,
    plan_fee        NUMBER(8)      NOT NULL,
    description     VARCHAR2(100)
);

CREATE TABLE trainer (
    trainer_id     NUMBER(3)      PRIMARY KEY,
    full_name      VARCHAR2(50)   NOT NULL,
    phone          VARCHAR2(15),
    specialization VARCHAR2(40),
    hire_date      DATE           NOT NULL,
    salary         NUMBER(8)      NOT NULL
);

CREATE TABLE member (
    member_id   NUMBER(4)      PRIMARY KEY,
    plan_id     NUMBER(3)      NOT NULL,
    full_name   VARCHAR2(50)   NOT NULL,
    gender      CHAR(1)        CHECK (gender IN ('M','F')),
    phone       VARCHAR2(15),
    email       VARCHAR2(60),
    join_date   DATE           NOT NULL,
    expiry_date DATE           NOT NULL,
    status      VARCHAR2(10)   DEFAULT 'Active' CHECK (status IN ('Active','Expired','Frozen')),
    CONSTRAINT fk_member_plan FOREIGN KEY (plan_id) REFERENCES membership_plan(plan_id)
);

CREATE TABLE gym_class (
    class_id   NUMBER(3)      PRIMARY KEY,
    trainer_id NUMBER(3)      NOT NULL,
    class_name VARCHAR2(40)   NOT NULL,
    class_day  VARCHAR2(10)   NOT NULL,
    start_time VARCHAR2(5)    NOT NULL,
    capacity   NUMBER(3)      NOT NULL,
    CONSTRAINT fk_class_trainer FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id)
);

CREATE TABLE class_enrollment (
    enrollment_id NUMBER(4)    PRIMARY KEY,
    member_id     NUMBER(4)    NOT NULL,
    class_id      NUMBER(3)    NOT NULL,
    enroll_date   DATE         NOT NULL,
    status        VARCHAR2(10) DEFAULT 'Enrolled' CHECK (status IN ('Enrolled','Completed','Cancelled')),
    CONSTRAINT fk_enr_member FOREIGN KEY (member_id) REFERENCES member(member_id),
    CONSTRAINT fk_enr_class  FOREIGN KEY (class_id)  REFERENCES gym_class(class_id),
    CONSTRAINT uq_member_class UNIQUE (member_id, class_id)
);

CREATE TABLE payment (
    payment_id   NUMBER(4)    PRIMARY KEY,
    member_id    NUMBER(4)    NOT NULL,
    amount       NUMBER(8)    NOT NULL,
    payment_date DATE         NOT NULL,
    method       VARCHAR2(15) CHECK (method IN ('Cash','Card','JazzCash','Easypaisa','Bank Transfer')),
    status       VARCHAR2(10) DEFAULT 'Paid' CHECK (status IN ('Paid','Pending')),
    CONSTRAINT fk_pay_member FOREIGN KEY (member_id) REFERENCES member(member_id)
);

CREATE TABLE attendance (
    attendance_id  NUMBER(4)  PRIMARY KEY,
    member_id      NUMBER(4)  NOT NULL,
    visit_date     DATE       NOT NULL,
    check_in_time  VARCHAR2(5) NOT NULL,
    check_out_time VARCHAR2(5),
    CONSTRAINT fk_att_member FOREIGN KEY (member_id) REFERENCES member(member_id)
);

INSERT INTO membership_plan VALUES (1, 'Monthly', 1, 5000, 'Gym floor access, one month');
INSERT INTO membership_plan VALUES (2, 'Quarterly', 3, 13500, 'Gym floor access, three months');
INSERT INTO membership_plan VALUES (3, 'Half-Yearly', 6, 25000, 'Gym floor access plus free classes');
INSERT INTO membership_plan VALUES (4, 'Yearly', 12, 45000, 'Full access, classes and locker');

INSERT INTO trainer VALUES (1, 'Kashif Mehmood', '0322-7624039', 'Weight Training', DATE '2023-11-02', 60000);
INSERT INTO trainer VALUES (2, 'Sadia Anwar', '0341-7135241', 'Cardio', DATE '2024-10-02', 90000);
INSERT INTO trainer VALUES (3, 'Rehan Ashraf', '0310-2441955', 'Yoga', DATE '2025-07-14', 60000);
INSERT INTO trainer VALUES (4, 'Nida Tariq', '0311-8122250', 'Zumba', DATE '2022-01-27', 90000);
INSERT INTO trainer VALUES (5, 'Farhan Aslam', '0303-2037872', 'CrossFit', DATE '2023-10-19', 80000);
INSERT INTO trainer VALUES (6, 'Bushra Naeem', '0303-1781527', 'Boxing', DATE '2024-09-28', 65000);
INSERT INTO trainer VALUES (7, 'Asad Mahmood', '0326-3420198', 'Pilates', DATE '2025-09-04', 90000);
INSERT INTO trainer VALUES (8, 'Hina Saleem', '0328-4032085', 'Spinning', DATE '2022-02-19', 90000);
INSERT INTO trainer VALUES (9, 'Tahir Iqbal', '0315-2634613', 'Strength and Conditioning', DATE '2023-09-23', 60000);
INSERT INTO trainer VALUES (10, 'Mahnoor Ali', '0340-4455413', 'Nutrition Coaching', DATE '2024-08-22', 90000);

INSERT INTO gym_class VALUES (1, 1, 'Morning Weights', 'Monday', '06:00', 20);
INSERT INTO gym_class VALUES (2, 2, 'Power Yoga', 'Tuesday', '07:00', 25);
INSERT INTO gym_class VALUES (3, 4, 'Zumba Party', 'Wednesday', '18:00', 30);
INSERT INTO gym_class VALUES (4, 3, 'CrossFit Basics', 'Thursday', '17:00', 15);
INSERT INTO gym_class VALUES (5, 5, 'Boxing Fundamentals', 'Friday', '19:00', 18);
INSERT INTO gym_class VALUES (6, 2, 'Cardio Blast', 'Saturday', '08:00', 30);
INSERT INTO gym_class VALUES (7, 8, 'Pilates Core', 'Sunday', '09:00', 20);
INSERT INTO gym_class VALUES (8, 10, 'Spin Ride', 'Monday', '18:30', 20);
INSERT INTO gym_class VALUES (9, 3, 'Strength Circuit', 'Tuesday', '19:00', 22);
INSERT INTO gym_class VALUES (10, 4, 'Evening Yoga', 'Thursday', '20:00', 25);
INSERT INTO gym_class VALUES (11, 6, 'Fat Burn HIIT', 'Saturday', '17:00', 25);
INSERT INTO gym_class VALUES (12, 10, 'Diet and Fitness Talk', 'Sunday', '16:00', 30);

-- member (120 rows)
INSERT INTO member VALUES (1, 2, 'Komal Chaudhry', 'F', '0324-5167906', 'komal.chaudhry@mail.com', DATE '2026-06-21', DATE '2026-09-21', 'Expired');
INSERT INTO member VALUES (2, 2, 'Faisal Malik', 'M', '0335-8530188', 'faisal.malik@mail.com', DATE '2026-07-27', DATE '2026-10-27', 'Expired');
INSERT INTO member VALUES (3, 1, 'Sidra Malik', 'F', '0315-3549877', 'sidra.malik@mail.com', DATE '2026-06-03', DATE '2026-07-03', 'Expired');
INSERT INTO member VALUES (4, 4, 'Nimra Khan', 'F', '0345-6706306', 'nimra.khan@mail.com', DATE '2025-12-10', DATE '2026-12-10', 'Active');
INSERT INTO member VALUES (5, 2, 'Sidra Siddiqui', 'F', '0301-5528829', 'sidra.siddiqui@mail.com', DATE '2026-06-22', DATE '2026-09-22', 'Expired');
INSERT INTO member VALUES (6, 1, 'Rabia Awan', 'F', '0347-5774720', 'rabia.awan@mail.com', DATE '2026-11-10', DATE '2026-12-10', 'Active');
INSERT INTO member VALUES (7, 1, 'Noor Awan', 'F', '0322-2964541', 'noor.awan@mail.com', DATE '2026-06-25', DATE '2026-07-25', 'Expired');
INSERT INTO member VALUES (8, 3, 'Ayesha Raza', 'F', '0316-7559047', 'ayesha.raza@mail.com', DATE '2026-01-06', DATE '2026-07-06', 'Expired');
INSERT INTO member VALUES (9, 2, 'Fatima Butt', 'F', '0322-8222954', 'fatima.butt@mail.com', DATE '2026-08-09', DATE '2026-11-09', 'Expired');
INSERT INTO member VALUES (10, 4, 'Rabia Qureshi', 'F', '0312-2392252', 'rabia.qureshi@mail.com', DATE '2026-10-16', DATE '2027-10-16', 'Active');
INSERT INTO member VALUES (11, 3, 'Bilal Raza', 'M', '0339-4059205', 'bilal.raza@mail.com', DATE '2025-11-07', DATE '2026-05-07', 'Expired');
INSERT INTO member VALUES (12, 1, 'Maryam Khan', 'F', '0329-6345416', 'maryam.khan@mail.com', DATE '2026-08-01', DATE '2026-09-01', 'Expired');
INSERT INTO member VALUES (13, 3, 'Rizwan Mirza', 'M', '0346-7678500', 'rizwan.mirza@mail.com', DATE '2026-11-14', DATE '2027-05-14', 'Frozen');
INSERT INTO member VALUES (14, 2, 'Nimra Malik', 'F', '0303-2129905', 'nimra.malik@mail.com', DATE '2026-05-25', DATE '2026-08-25', 'Expired');
INSERT INTO member VALUES (15, 1, 'Danish Butt', 'M', '0301-1003913', 'danish.butt@mail.com', DATE '2026-09-04', DATE '2026-10-04', 'Expired');
INSERT INTO member VALUES (16, 4, 'Shahid Malik', 'M', '0319-7312081', 'shahid.malik@mail.com', DATE '2026-09-11', DATE '2027-09-11', 'Frozen');
INSERT INTO member VALUES (17, 2, 'Imran Chaudhry', 'M', '0301-9188423', 'imran.chaudhry@mail.com', DATE '2026-07-01', DATE '2026-10-01', 'Expired');
INSERT INTO member VALUES (18, 1, 'Iqra Siddiqui', 'F', '0305-5441883', 'iqra.siddiqui@mail.com', DATE '2026-01-13', DATE '2026-02-13', 'Expired');
INSERT INTO member VALUES (19, 1, 'Anam Rana', 'F', '0318-7069199', 'anam.rana@mail.com', DATE '2025-11-12', DATE '2025-12-12', 'Expired');
INSERT INTO member VALUES (20, 1, 'Shahid Niazi', 'M', '0321-5380786', 'shahid.niazi@mail.com', DATE '2026-07-29', DATE '2026-08-29', 'Expired');
INSERT INTO member VALUES (21, 2, 'Noor Butt', 'F', '0348-9433856', 'noor.butt@mail.com', DATE '2026-02-23', DATE '2026-05-23', 'Expired');
INSERT INTO member VALUES (22, 2, 'Mehwish Raza', 'F', '0316-4804057', 'mehwish.raza@mail.com', DATE '2026-02-08', DATE '2026-05-08', 'Expired');
INSERT INTO member VALUES (23, 2, 'Rizwan Siddiqui', 'M', '0304-8922873', 'rizwan.siddiqui@mail.com', DATE '2025-11-15', DATE '2026-02-15', 'Expired');
INSERT INTO member VALUES (24, 2, 'Hira Rana', 'F', '0335-7117575', 'hira.rana@mail.com', DATE '2026-04-26', DATE '2026-07-26', 'Expired');
INSERT INTO member VALUES (25, 1, 'Adeel Raza', 'M', '0349-1032016', 'adeel.raza@mail.com', DATE '2026-07-06', DATE '2026-08-06', 'Expired');
INSERT INTO member VALUES (26, 1, 'Komal Awan', 'F', '0306-4344024', 'komal.awan@mail.com', DATE '2026-10-05', DATE '2026-11-05', 'Expired');
INSERT INTO member VALUES (27, 4, 'Fatima Javed', 'F', '0331-3665162', 'fatima.javed@mail.com', DATE '2026-11-05', DATE '2027-11-05', 'Active');
INSERT INTO member VALUES (28, 1, 'Bilal Khan', 'M', '0319-8958388', 'bilal.khan@mail.com', DATE '2026-06-27', DATE '2026-07-27', 'Expired');
INSERT INTO member VALUES (29, 2, 'Sana Abbasi', 'F', '0301-9834563', 'sana.abbasi@mail.com', DATE '2025-11-11', DATE '2026-02-11', 'Expired');
INSERT INTO member VALUES (30, 1, 'Waqas Hussain', 'M', '0304-4569852', 'waqas.hussain@mail.com', DATE '2026-02-17', DATE '2026-03-17', 'Expired');
INSERT INTO member VALUES (31, 3, 'Areeba Raza', 'F', '0328-8029864', 'areeba.raza@mail.com', DATE '2026-04-16', DATE '2026-10-16', 'Expired');
INSERT INTO member VALUES (32, 3, 'Ali Niazi', 'M', '0346-9416272', 'ali.niazi@mail.com', DATE '2026-06-23', DATE '2026-12-23', 'Active');
INSERT INTO member VALUES (33, 2, 'Shahid Butt', 'M', '0332-1065976', 'shahid.butt@mail.com', DATE '2025-11-10', DATE '2026-02-10', 'Expired');
INSERT INTO member VALUES (34, 2, 'Hassan Butt', 'M', '0305-9696448', 'hassan.butt@mail.com', DATE '2026-11-07', DATE '2027-02-07', 'Active');
INSERT INTO member VALUES (35, 1, 'Komal Javed', 'F', '0303-4209584', 'komal.javed@mail.com', DATE '2026-08-14', DATE '2026-09-14', 'Expired');
INSERT INTO member VALUES (36, 1, 'Ayesha Javed', 'F', '0340-2063152', 'ayesha.javed@mail.com', DATE '2026-06-20', DATE '2026-07-20', 'Expired');
INSERT INTO member VALUES (37, 4, 'Zainab Mirza', 'F', '0327-9525445', 'zainab.mirza@mail.com', DATE '2026-09-07', DATE '2027-09-07', 'Active');
INSERT INTO member VALUES (38, 4, 'Noor Abbasi', 'F', '0316-3040477', 'noor.abbasi@mail.com', DATE '2026-02-12', DATE '2027-02-12', 'Active');
INSERT INTO member VALUES (39, 1, 'Iqra Chaudhry', 'F', '0331-4568342', 'iqra.chaudhry@mail.com', DATE '2026-03-04', DATE '2026-04-04', 'Expired');
INSERT INTO member VALUES (40, 4, 'Komal Malik', 'F', '0322-5246444', 'komal.malik@mail.com', DATE '2026-01-19', DATE '2027-01-19', 'Active');
INSERT INTO member VALUES (41, 3, 'Danish Raza', 'M', '0337-3731249', 'danish.raza@mail.com', DATE '2025-12-19', DATE '2026-06-19', 'Expired');
INSERT INTO member VALUES (42, 2, 'Hassan Rana', 'M', '0335-8067846', 'hassan.rana@mail.com', DATE '2026-07-22', DATE '2026-10-22', 'Expired');
INSERT INTO member VALUES (43, 1, 'Talha Chaudhry', 'M', '0305-8695218', 'talha.chaudhry@mail.com', DATE '2026-05-07', DATE '2026-06-07', 'Expired');
INSERT INTO member VALUES (44, 2, 'Rabia Khan', 'F', '0344-9594334', 'rabia.khan@mail.com', DATE '2026-07-23', DATE '2026-10-23', 'Expired');
INSERT INTO member VALUES (45, 3, 'Hamza Niazi', 'M', '0304-5562068', 'hamza.niazi@mail.com', DATE '2025-12-24', DATE '2026-06-24', 'Expired');
INSERT INTO member VALUES (46, 3, 'Hassan Sheikh', 'M', '0326-3505978', 'hassan.sheikh@mail.com', DATE '2026-06-05', DATE '2026-12-05', 'Active');
INSERT INTO member VALUES (47, 1, 'Rabia Chaudhry', 'F', '0316-2214906', 'rabia.chaudhry@mail.com', DATE '2025-11-30', DATE '2025-12-30', 'Expired');
INSERT INTO member VALUES (48, 1, 'Ayesha Awan', 'F', '0309-4731386', 'ayesha.awan@mail.com', DATE '2026-03-14', DATE '2026-04-14', 'Expired');
INSERT INTO member VALUES (49, 1, 'Imran Hussain', 'M', '0328-8008855', 'imran.hussain@mail.com', DATE '2025-11-06', DATE '2025-12-06', 'Expired');
INSERT INTO member VALUES (50, 1, 'Sidra Butt', 'F', '0302-5393873', 'sidra.butt@mail.com', DATE '2026-10-30', DATE '2026-11-30', 'Active');
INSERT INTO member VALUES (51, 4, 'Hassan Raza', 'M', '0314-8477384', 'hassan.raza@mail.com', DATE '2026-09-18', DATE '2027-09-18', 'Active');
INSERT INTO member VALUES (52, 1, 'Imran Khan', 'M', '0318-8965161', 'imran.khan@mail.com', DATE '2026-11-11', DATE '2026-12-11', 'Active');
INSERT INTO member VALUES (53, 3, 'Danish Malik', 'M', '0338-7594889', 'danish.malik@mail.com', DATE '2026-09-29', DATE '2027-03-29', 'Active');
INSERT INTO member VALUES (54, 4, 'Rabia Raza', 'F', '0316-6830957', 'rabia.raza@mail.com', DATE '2026-04-25', DATE '2027-04-25', 'Active');
INSERT INTO member VALUES (55, 1, 'Imran Qureshi', 'M', '0338-5730055', 'imran.qureshi@mail.com', DATE '2025-12-14', DATE '2026-01-14', 'Expired');
INSERT INTO member VALUES (56, 2, 'Kamran Khan', 'M', '0327-1060779', 'kamran.khan@mail.com', DATE '2026-01-20', DATE '2026-04-20', 'Expired');
INSERT INTO member VALUES (57, 4, 'Zainab Chaudhry', 'F', '0304-4655182', 'zainab.chaudhry@mail.com', DATE '2026-08-08', DATE '2027-08-08', 'Active');
INSERT INTO member VALUES (58, 1, 'Sana Khan', 'F', '0334-9434980', 'sana.khan@mail.com', DATE '2025-12-13', DATE '2026-01-13', 'Expired');
INSERT INTO member VALUES (59, 3, 'Faisal Abbasi', 'M', '0321-3413656', 'faisal.abbasi@mail.com', DATE '2025-12-17', DATE '2026-06-17', 'Expired');
INSERT INTO member VALUES (60, 2, 'Sidra Khan', 'F', '0323-2417384', 'sidra.khan@mail.com', DATE '2026-04-03', DATE '2026-07-03', 'Expired');
INSERT INTO member VALUES (61, 3, 'Junaid Qureshi', 'M', '0314-3428539', 'junaid.qureshi@mail.com', DATE '2026-11-04', DATE '2027-05-04', 'Active');
INSERT INTO member VALUES (62, 2, 'Rizwan Awan', 'M', '0318-9461942', 'rizwan.awan@mail.com', DATE '2026-10-25', DATE '2027-01-25', 'Active');
INSERT INTO member VALUES (63, 4, 'Nadeem Javed', 'M', '0311-1522786', 'nadeem.javed@mail.com', DATE '2026-10-16', DATE '2027-10-16', 'Active');
INSERT INTO member VALUES (64, 2, 'Bilal Awan', 'M', '0337-1851952', 'bilal.awan@mail.com', DATE '2025-12-24', DATE '2026-03-24', 'Expired');
INSERT INTO member VALUES (65, 1, 'Shahid Awan', 'M', '0307-2176276', 'shahid.awan@mail.com', DATE '2026-03-16', DATE '2026-04-16', 'Expired');
INSERT INTO member VALUES (66, 3, 'Rizwan Malik', 'M', '0304-4939049', 'rizwan.malik@mail.com', DATE '2026-07-01', DATE '2027-01-01', 'Active');
INSERT INTO member VALUES (67, 2, 'Faisal Rana', 'M', '0336-2287481', 'faisal.rana@mail.com', DATE '2026-06-24', DATE '2026-09-24', 'Expired');
INSERT INTO member VALUES (68, 2, 'Komal Khan', 'F', '0342-6566226', 'komal.khan@mail.com', DATE '2026-09-26', DATE '2026-12-26', 'Active');
INSERT INTO member VALUES (69, 3, 'Mehwish Rana', 'F', '0307-2017722', 'mehwish.rana@mail.com', DATE '2026-09-15', DATE '2027-03-15', 'Active');
INSERT INTO member VALUES (70, 1, 'Maryam Awan', 'F', '0334-9666030', 'maryam.awan@mail.com', DATE '2026-02-20', DATE '2026-03-20', 'Expired');
INSERT INTO member VALUES (71, 4, 'Kamran Malik', 'M', '0327-2282857', 'kamran.malik@mail.com', DATE '2025-11-09', DATE '2026-11-09', 'Expired');
INSERT INTO member VALUES (72, 1, 'Maryam Qureshi', 'F', '0309-2515034', 'maryam.qureshi@mail.com', DATE '2026-02-16', DATE '2026-03-16', 'Expired');
INSERT INTO member VALUES (73, 4, 'Rizwan Sheikh', 'M', '0344-2890415', 'rizwan.sheikh@mail.com', DATE '2026-01-07', DATE '2027-01-07', 'Active');
INSERT INTO member VALUES (74, 4, 'Hira Siddiqui', 'F', '0310-9249291', 'hira.siddiqui@mail.com', DATE '2026-07-07', DATE '2027-07-07', 'Active');
INSERT INTO member VALUES (75, 3, 'Nimra Sheikh', 'F', '0321-6558700', 'nimra.sheikh@mail.com', DATE '2026-06-02', DATE '2026-12-02', 'Active');
INSERT INTO member VALUES (76, 1, 'Saad Javed', 'M', '0303-1196656', 'saad.javed@mail.com', DATE '2026-05-23', DATE '2026-06-23', 'Expired');
INSERT INTO member VALUES (77, 1, 'Maryam Chaudhry', 'F', '0341-7051698', 'maryam.chaudhry@mail.com', DATE '2026-05-19', DATE '2026-06-19', 'Expired');
INSERT INTO member VALUES (78, 4, 'Komal Sheikh', 'F', '0322-5182974', 'komal.sheikh@mail.com', DATE '2026-03-24', DATE '2027-03-24', 'Active');
INSERT INTO member VALUES (79, 1, 'Nimra Abbasi', 'F', '0330-7711585', 'nimra.abbasi@mail.com', DATE '2026-05-11', DATE '2026-06-11', 'Expired');
INSERT INTO member VALUES (80, 4, 'Usman Khan', 'M', '0314-9146598', 'usman.khan@mail.com', DATE '2026-05-30', DATE '2027-05-30', 'Active');
INSERT INTO member VALUES (81, 1, 'Adeel Qureshi', 'M', '0324-7815060', 'adeel.qureshi@mail.com', DATE '2026-04-02', DATE '2026-05-02', 'Expired');
INSERT INTO member VALUES (82, 2, 'Kamran Siddiqui', 'M', '0302-3712153', 'kamran.siddiqui@mail.com', DATE '2026-05-21', DATE '2026-08-21', 'Expired');
INSERT INTO member VALUES (83, 4, 'Zain Abbasi', 'M', '0335-8549083', 'zain.abbasi@mail.com', DATE '2026-07-13', DATE '2027-07-13', 'Active');
INSERT INTO member VALUES (84, 1, 'Saad Abbasi', 'M', '0324-4391377', 'saad.abbasi@mail.com', DATE '2026-03-03', DATE '2026-04-03', 'Expired');
INSERT INTO member VALUES (85, 2, 'Waqas Qureshi', 'M', '0316-5533872', 'waqas.qureshi@mail.com', DATE '2026-07-27', DATE '2026-10-27', 'Expired');
INSERT INTO member VALUES (86, 4, 'Maryam Mirza', 'F', '0343-2553539', 'maryam.mirza@mail.com', DATE '2026-01-04', DATE '2027-01-04', 'Active');
INSERT INTO member VALUES (87, 2, 'Noor Raza', 'F', '0320-3134850', 'noor.raza@mail.com', DATE '2026-09-27', DATE '2026-12-27', 'Active');
INSERT INTO member VALUES (88, 3, 'Waqas Rana', 'M', '0330-2227050', 'waqas.rana@mail.com', DATE '2026-07-01', DATE '2027-01-01', 'Active');
INSERT INTO member VALUES (89, 4, 'Noor Niazi', 'F', '0333-2829488', 'noor.niazi@mail.com', DATE '2026-07-29', DATE '2027-07-29', 'Active');
INSERT INTO member VALUES (90, 2, 'Bilal Butt', 'M', '0331-1663476', 'bilal.butt@mail.com', DATE '2026-10-16', DATE '2027-01-16', 'Active');
INSERT INTO member VALUES (91, 2, 'Kamran Butt', 'M', '0331-2668406', 'kamran.butt@mail.com', DATE '2026-07-29', DATE '2026-10-29', 'Expired');
INSERT INTO member VALUES (92, 4, 'Kamran Abbasi', 'M', '0319-1019327', 'kamran.abbasi@mail.com', DATE '2026-02-07', DATE '2027-02-07', 'Active');
INSERT INTO member VALUES (93, 4, 'Shahid Sheikh', 'M', '0317-9829474', 'shahid.sheikh@mail.com', DATE '2026-03-23', DATE '2027-03-23', 'Active');
INSERT INTO member VALUES (94, 1, 'Shahid Raza', 'M', '0320-1365531', 'shahid.raza@mail.com', DATE '2026-05-30', DATE '2026-06-30', 'Expired');
INSERT INTO member VALUES (95, 3, 'Adeel Niazi', 'M', '0316-7211227', 'adeel.niazi@mail.com', DATE '2026-06-04', DATE '2026-12-04', 'Active');
INSERT INTO member VALUES (96, 3, 'Adeel Khan', 'M', '0333-1113304', 'adeel.khan@mail.com', DATE '2026-11-03', DATE '2027-05-03', 'Active');
INSERT INTO member VALUES (97, 2, 'Rabia Hussain', 'F', '0333-6229722', 'rabia.hussain@mail.com', DATE '2026-02-14', DATE '2026-05-14', 'Expired');
INSERT INTO member VALUES (98, 1, 'Faisal Siddiqui', 'M', '0309-9317551', 'faisal.siddiqui@mail.com', DATE '2026-04-01', DATE '2026-05-01', 'Expired');
INSERT INTO member VALUES (99, 4, 'Junaid Butt', 'M', '0342-7969002', 'junaid.butt@mail.com', DATE '2025-11-28', DATE '2026-11-28', 'Active');
INSERT INTO member VALUES (100, 2, 'Ali Butt', 'M', '0301-3778873', 'ali.butt@mail.com', DATE '2026-10-31', DATE '2027-01-31', 'Active');
INSERT INTO member VALUES (101, 3, 'Hira Butt', 'F', '0304-7352179', 'hira.butt@mail.com', DATE '2026-07-27', DATE '2027-01-27', 'Active');
INSERT INTO member VALUES (102, 1, 'Zainab Siddiqui', 'F', '0304-2354977', 'zainab.siddiqui@mail.com', DATE '2025-11-02', DATE '2025-12-02', 'Expired');
INSERT INTO member VALUES (103, 1, 'Nimra Niazi', 'F', '0335-6179113', 'nimra.niazi@mail.com', DATE '2026-02-15', DATE '2026-03-15', 'Expired');
INSERT INTO member VALUES (104, 3, 'Fatima Khan', 'F', '0328-8488468', 'fatima.khan@mail.com', DATE '2026-02-09', DATE '2026-08-09', 'Expired');
INSERT INTO member VALUES (105, 3, 'Saad Chaudhry', 'M', '0333-7790957', 'saad.chaudhry@mail.com', DATE '2026-07-01', DATE '2027-01-01', 'Frozen');
INSERT INTO member VALUES (106, 2, 'Umar Khan', 'M', '0323-2054477', 'umar.khan@mail.com', DATE '2025-12-02', DATE '2026-03-02', 'Expired');
INSERT INTO member VALUES (107, 1, 'Zainab Sheikh', 'F', '0304-6309714', 'zainab.sheikh@mail.com', DATE '2026-09-12', DATE '2026-10-12', 'Expired');
INSERT INTO member VALUES (108, 1, 'Ahmed Hussain', 'M', '0336-5211866', 'ahmed.hussain@mail.com', DATE '2026-07-02', DATE '2026-08-02', 'Expired');
INSERT INTO member VALUES (109, 1, 'Anam Siddiqui', 'F', '0310-6088777', 'anam.siddiqui@mail.com', DATE '2026-07-13', DATE '2026-08-13', 'Expired');
INSERT INTO member VALUES (110, 1, 'Junaid Raza', 'M', '0335-2325649', 'junaid.raza@mail.com', DATE '2026-04-13', DATE '2026-05-13', 'Expired');
INSERT INTO member VALUES (111, 1, 'Umar Javed', 'M', '0300-9081415', 'umar.javed@mail.com', DATE '2026-05-28', DATE '2026-06-28', 'Expired');
INSERT INTO member VALUES (112, 4, 'Sana Qureshi', 'F', '0303-2617702', 'sana.qureshi@mail.com', DATE '2025-12-07', DATE '2026-12-07', 'Active');
INSERT INTO member VALUES (113, 4, 'Iqra Rana', 'F', '0337-4941526', 'iqra.rana@mail.com', DATE '2026-01-28', DATE '2027-01-28', 'Active');
INSERT INTO member VALUES (114, 1, 'Kamran Sheikh', 'M', '0324-5367697', 'kamran.sheikh@mail.com', DATE '2026-03-18', DATE '2026-04-18', 'Expired');
INSERT INTO member VALUES (115, 1, 'Faisal Raza', 'M', '0315-2087232', 'faisal.raza@mail.com', DATE '2026-08-24', DATE '2026-09-24', 'Expired');
INSERT INTO member VALUES (116, 2, 'Maryam Raza', 'F', '0307-1621145', 'maryam.raza@mail.com', DATE '2026-02-27', DATE '2026-05-27', 'Expired');
INSERT INTO member VALUES (117, 4, 'Ahmed Siddiqui', 'M', '0320-5927090', 'ahmed.siddiqui@mail.com', DATE '2026-02-27', DATE '2027-02-27', 'Active');
INSERT INTO member VALUES (118, 1, 'Hamza Khan', 'M', '0311-7245099', 'hamza.khan@mail.com', DATE '2026-08-26', DATE '2026-09-26', 'Expired');
INSERT INTO member VALUES (119, 1, 'Danish Mirza', 'M', '0301-6866986', 'danish.mirza@mail.com', DATE '2026-10-07', DATE '2026-11-07', 'Expired');
INSERT INTO member VALUES (120, 1, 'Ali Chaudhry', 'M', '0314-1641493', 'ali.chaudhry@mail.com', DATE '2025-11-23', DATE '2025-12-23', 'Expired');

INSERT INTO class_enrollment VALUES (1, 17, 5, DATE '2026-07-14', 'Completed');
INSERT INTO class_enrollment VALUES (2, 36, 4, DATE '2026-06-22', 'Completed');
INSERT INTO class_enrollment VALUES (3, 37, 8, DATE '2026-09-26', 'Completed');
INSERT INTO class_enrollment VALUES (4, 29, 11, DATE '2025-11-23', 'Enrolled');
INSERT INTO class_enrollment VALUES (5, 91, 6, DATE '2026-08-12', 'Cancelled');
INSERT INTO class_enrollment VALUES (6, 39, 10, DATE '2026-03-19', 'Enrolled');
INSERT INTO class_enrollment VALUES (7, 40, 1, DATE '2026-01-26', 'Enrolled');
INSERT INTO class_enrollment VALUES (8, 25, 9, DATE '2026-07-23', 'Enrolled');
INSERT INTO class_enrollment VALUES (9, 75, 7, DATE '2026-06-02', 'Cancelled');
INSERT INTO class_enrollment VALUES (10, 21, 4, DATE '2026-03-05', 'Completed');
INSERT INTO class_enrollment VALUES (11, 63, 5, DATE '2026-10-25', 'Cancelled');
INSERT INTO class_enrollment VALUES (12, 28, 5, DATE '2026-06-28', 'Completed');
INSERT INTO class_enrollment VALUES (13, 21, 9, DATE '2026-02-25', 'Completed');
INSERT INTO class_enrollment VALUES (14, 45, 8, DATE '2025-12-25', 'Completed');
INSERT INTO class_enrollment VALUES (15, 107, 8, DATE '2026-09-23', 'Completed');
INSERT INTO class_enrollment VALUES (16, 14, 9, DATE '2026-06-01', 'Cancelled');
INSERT INTO class_enrollment VALUES (17, 87, 12, DATE '2026-10-01', 'Enrolled');
INSERT INTO class_enrollment VALUES (18, 86, 6, DATE '2026-01-08', 'Completed');
INSERT INTO class_enrollment VALUES (19, 79, 10, DATE '2026-05-19', 'Completed');
INSERT INTO class_enrollment VALUES (20, 67, 2, DATE '2026-07-09', 'Enrolled');
INSERT INTO class_enrollment VALUES (21, 81, 12, DATE '2026-04-22', 'Cancelled');
INSERT INTO class_enrollment VALUES (22, 17, 7, DATE '2026-07-04', 'Enrolled');
INSERT INTO class_enrollment VALUES (23, 99, 9, DATE '2025-12-16', 'Enrolled');
INSERT INTO class_enrollment VALUES (24, 51, 10, DATE '2026-09-22', 'Enrolled');
INSERT INTO class_enrollment VALUES (25, 101, 5, DATE '2026-08-15', 'Completed');
INSERT INTO class_enrollment VALUES (26, 49, 8, DATE '2025-11-20', 'Enrolled');
INSERT INTO class_enrollment VALUES (27, 46, 5, DATE '2026-06-16', 'Enrolled');
INSERT INTO class_enrollment VALUES (28, 72, 10, DATE '2026-02-28', 'Completed');
INSERT INTO class_enrollment VALUES (29, 1, 12, DATE '2026-07-06', 'Enrolled');
INSERT INTO class_enrollment VALUES (30, 39, 3, DATE '2026-03-21', 'Enrolled');
INSERT INTO class_enrollment VALUES (31, 19, 7, DATE '2025-11-30', 'Enrolled');
INSERT INTO class_enrollment VALUES (32, 30, 2, DATE '2026-02-27', 'Enrolled');
INSERT INTO class_enrollment VALUES (33, 108, 10, DATE '2026-07-09', 'Cancelled');
INSERT INTO class_enrollment VALUES (34, 27, 7, DATE '2026-11-05', 'Enrolled');
INSERT INTO class_enrollment VALUES (35, 33, 10, DATE '2025-11-25', 'Enrolled');
INSERT INTO class_enrollment VALUES (36, 69, 5, DATE '2026-10-02', 'Completed');
INSERT INTO class_enrollment VALUES (37, 56, 9, DATE '2026-02-05', 'Completed');
INSERT INTO class_enrollment VALUES (38, 56, 7, DATE '2026-02-03', 'Enrolled');
INSERT INTO class_enrollment VALUES (39, 77, 11, DATE '2026-05-30', 'Enrolled');
INSERT INTO class_enrollment VALUES (40, 2, 11, DATE '2026-07-29', 'Completed');
INSERT INTO class_enrollment VALUES (41, 13, 7, DATE '2026-11-25', 'Completed');
INSERT INTO class_enrollment VALUES (42, 84, 9, DATE '2026-03-21', 'Enrolled');
INSERT INTO class_enrollment VALUES (43, 25, 7, DATE '2026-07-21', 'Enrolled');
INSERT INTO class_enrollment VALUES (44, 99, 10, DATE '2025-12-16', 'Enrolled');
INSERT INTO class_enrollment VALUES (45, 68, 12, DATE '2026-09-28', 'Enrolled');
INSERT INTO class_enrollment VALUES (46, 41, 6, DATE '2025-12-21', 'Completed');
INSERT INTO class_enrollment VALUES (47, 66, 3, DATE '2026-07-04', 'Completed');
INSERT INTO class_enrollment VALUES (48, 38, 12, DATE '2026-02-22', 'Completed');
INSERT INTO class_enrollment VALUES (49, 66, 7, DATE '2026-07-21', 'Enrolled');
INSERT INTO class_enrollment VALUES (50, 38, 9, DATE '2026-02-18', 'Completed');
INSERT INTO class_enrollment VALUES (51, 24, 1, DATE '2026-05-16', 'Completed');
INSERT INTO class_enrollment VALUES (52, 14, 6, DATE '2026-06-12', 'Cancelled');
INSERT INTO class_enrollment VALUES (53, 82, 12, DATE '2026-05-22', 'Completed');
INSERT INTO class_enrollment VALUES (54, 2, 1, DATE '2026-08-05', 'Completed');
INSERT INTO class_enrollment VALUES (55, 71, 1, DATE '2025-11-18', 'Enrolled');
INSERT INTO class_enrollment VALUES (56, 13, 10, DATE '2026-11-14', 'Completed');
INSERT INTO class_enrollment VALUES (57, 26, 3, DATE '2026-10-20', 'Completed');
INSERT INTO class_enrollment VALUES (58, 73, 5, DATE '2026-01-27', 'Cancelled');
INSERT INTO class_enrollment VALUES (59, 74, 4, DATE '2026-07-20', 'Completed');
INSERT INTO class_enrollment VALUES (60, 19, 3, DATE '2025-11-28', 'Completed');
INSERT INTO class_enrollment VALUES (61, 14, 1, DATE '2026-05-28', 'Enrolled');
INSERT INTO class_enrollment VALUES (62, 67, 8, DATE '2026-07-08', 'Completed');
INSERT INTO class_enrollment VALUES (63, 104, 1, DATE '2026-03-01', 'Enrolled');
INSERT INTO class_enrollment VALUES (64, 42, 3, DATE '2026-07-29', 'Enrolled');
INSERT INTO class_enrollment VALUES (65, 22, 1, DATE '2026-02-16', 'Completed');
INSERT INTO class_enrollment VALUES (66, 110, 10, DATE '2026-04-15', 'Enrolled');
INSERT INTO class_enrollment VALUES (67, 58, 10, DATE '2025-12-25', 'Enrolled');
INSERT INTO class_enrollment VALUES (68, 29, 7, DATE '2025-11-29', 'Completed');
INSERT INTO class_enrollment VALUES (69, 6, 8, DATE '2026-11-11', 'Completed');
INSERT INTO class_enrollment VALUES (70, 32, 4, DATE '2026-06-24', 'Enrolled');
INSERT INTO class_enrollment VALUES (71, 76, 3, DATE '2026-06-02', 'Enrolled');
INSERT INTO class_enrollment VALUES (72, 111, 8, DATE '2026-06-06', 'Enrolled');
INSERT INTO class_enrollment VALUES (73, 33, 8, DATE '2025-11-12', 'Enrolled');
INSERT INTO class_enrollment VALUES (74, 50, 11, DATE '2026-11-17', 'Enrolled');
INSERT INTO class_enrollment VALUES (75, 40, 7, DATE '2026-02-03', 'Enrolled');
INSERT INTO class_enrollment VALUES (76, 112, 4, DATE '2025-12-09', 'Enrolled');
INSERT INTO class_enrollment VALUES (77, 46, 7, DATE '2026-06-10', 'Enrolled');
INSERT INTO class_enrollment VALUES (78, 113, 5, DATE '2026-02-09', 'Completed');
INSERT INTO class_enrollment VALUES (79, 15, 6, DATE '2026-09-21', 'Cancelled');
INSERT INTO class_enrollment VALUES (80, 43, 7, DATE '2026-05-27', 'Enrolled');
INSERT INTO class_enrollment VALUES (81, 16, 7, DATE '2026-09-22', 'Completed');
INSERT INTO class_enrollment VALUES (82, 50, 4, DATE '2026-11-13', 'Enrolled');
INSERT INTO class_enrollment VALUES (83, 31, 7, DATE '2026-04-17', 'Enrolled');
INSERT INTO class_enrollment VALUES (84, 4, 6, DATE '2025-12-14', 'Enrolled');
INSERT INTO class_enrollment VALUES (85, 17, 2, DATE '2026-07-07', 'Enrolled');
INSERT INTO class_enrollment VALUES (86, 107, 3, DATE '2026-09-29', 'Enrolled');
INSERT INTO class_enrollment VALUES (87, 108, 4, DATE '2026-07-07', 'Enrolled');
INSERT INTO class_enrollment VALUES (88, 28, 12, DATE '2026-07-09', 'Enrolled');
INSERT INTO class_enrollment VALUES (89, 75, 4, DATE '2026-06-11', 'Cancelled');
INSERT INTO class_enrollment VALUES (90, 65, 4, DATE '2026-03-23', 'Cancelled');
INSERT INTO class_enrollment VALUES (91, 87, 3, DATE '2026-10-05', 'Completed');
INSERT INTO class_enrollment VALUES (92, 57, 10, DATE '2026-08-19', 'Completed');
INSERT INTO class_enrollment VALUES (93, 52, 10, DATE '2026-11-27', 'Enrolled');
INSERT INTO class_enrollment VALUES (94, 112, 2, DATE '2025-12-23', 'Enrolled');
INSERT INTO class_enrollment VALUES (95, 110, 5, DATE '2026-04-25', 'Enrolled');
INSERT INTO class_enrollment VALUES (96, 92, 10, DATE '2026-02-11', 'Enrolled');
INSERT INTO class_enrollment VALUES (97, 50, 12, DATE '2026-11-01', 'Completed');
INSERT INTO class_enrollment VALUES (98, 100, 4, DATE '2026-11-10', 'Enrolled');
INSERT INTO class_enrollment VALUES (99, 115, 2, DATE '2026-08-26', 'Completed');
INSERT INTO class_enrollment VALUES (100, 47, 9, DATE '2025-12-09', 'Enrolled');
INSERT INTO class_enrollment VALUES (101, 92, 5, DATE '2026-02-09', 'Enrolled');
INSERT INTO class_enrollment VALUES (102, 17, 12, DATE '2026-07-13', 'Enrolled');
INSERT INTO class_enrollment VALUES (103, 52, 8, DATE '2026-12-01', 'Cancelled');
INSERT INTO class_enrollment VALUES (104, 111, 3, DATE '2026-06-05', 'Enrolled');
INSERT INTO class_enrollment VALUES (105, 47, 11, DATE '2025-12-11', 'Cancelled');
INSERT INTO class_enrollment VALUES (106, 4, 11, DATE '2025-12-24', 'Enrolled');
INSERT INTO class_enrollment VALUES (107, 109, 7, DATE '2026-07-24', 'Cancelled');
INSERT INTO class_enrollment VALUES (108, 13, 3, DATE '2026-11-23', 'Enrolled');
INSERT INTO class_enrollment VALUES (109, 117, 10, DATE '2026-03-06', 'Completed');
INSERT INTO class_enrollment VALUES (110, 6, 7, DATE '2026-11-11', 'Completed');
INSERT INTO class_enrollment VALUES (111, 56, 4, DATE '2026-01-29', 'Enrolled');
INSERT INTO class_enrollment VALUES (112, 95, 1, DATE '2026-06-21', 'Enrolled');
INSERT INTO class_enrollment VALUES (113, 82, 3, DATE '2026-06-08', 'Completed');
INSERT INTO class_enrollment VALUES (114, 73, 8, DATE '2026-01-23', 'Enrolled');
INSERT INTO class_enrollment VALUES (115, 56, 11, DATE '2026-02-07', 'Enrolled');
INSERT INTO class_enrollment VALUES (116, 1, 2, DATE '2026-07-11', 'Enrolled');
INSERT INTO class_enrollment VALUES (117, 6, 10, DATE '2026-11-29', 'Completed');
INSERT INTO class_enrollment VALUES (118, 32, 11, DATE '2026-06-26', 'Enrolled');
INSERT INTO class_enrollment VALUES (119, 41, 4, DATE '2025-12-30', 'Completed');
INSERT INTO class_enrollment VALUES (120, 12, 7, DATE '2026-08-13', 'Cancelled');
INSERT INTO class_enrollment VALUES (121, 79, 4, DATE '2026-05-19', 'Completed');
INSERT INTO class_enrollment VALUES (122, 45, 7, DATE '2026-01-07', 'Cancelled');
INSERT INTO class_enrollment VALUES (123, 89, 9, DATE '2026-08-18', 'Completed');
INSERT INTO class_enrollment VALUES (124, 66, 1, DATE '2026-07-07', 'Enrolled');
INSERT INTO class_enrollment VALUES (125, 63, 4, DATE '2026-10-17', 'Cancelled');
INSERT INTO class_enrollment VALUES (126, 106, 9, DATE '2025-12-10', 'Enrolled');
INSERT INTO class_enrollment VALUES (127, 21, 11, DATE '2026-03-02', 'Completed');
INSERT INTO class_enrollment VALUES (128, 32, 1, DATE '2026-06-28', 'Enrolled');
INSERT INTO class_enrollment VALUES (129, 53, 2, DATE '2026-10-05', 'Completed');
INSERT INTO class_enrollment VALUES (130, 18, 3, DATE '2026-01-28', 'Completed');
INSERT INTO class_enrollment VALUES (131, 31, 12, DATE '2026-04-23', 'Enrolled');
INSERT INTO class_enrollment VALUES (132, 89, 8, DATE '2026-08-02', 'Cancelled');
INSERT INTO class_enrollment VALUES (133, 45, 12, DATE '2026-01-02', 'Enrolled');
INSERT INTO class_enrollment VALUES (134, 91, 3, DATE '2026-08-16', 'Completed');
INSERT INTO class_enrollment VALUES (135, 43, 11, DATE '2026-05-10', 'Completed');
INSERT INTO class_enrollment VALUES (136, 98, 3, DATE '2026-04-05', 'Completed');
INSERT INTO class_enrollment VALUES (137, 60, 7, DATE '2026-04-09', 'Enrolled');
INSERT INTO class_enrollment VALUES (138, 38, 1, DATE '2026-02-23', 'Enrolled');
INSERT INTO class_enrollment VALUES (139, 6, 1, DATE '2026-11-18', 'Enrolled');
INSERT INTO class_enrollment VALUES (140, 15, 12, DATE '2026-09-13', 'Enrolled');
INSERT INTO class_enrollment VALUES (141, 15, 3, DATE '2026-09-14', 'Enrolled');
INSERT INTO class_enrollment VALUES (142, 73, 6, DATE '2026-01-16', 'Enrolled');
INSERT INTO class_enrollment VALUES (143, 10, 1, DATE '2026-10-16', 'Enrolled');
INSERT INTO class_enrollment VALUES (144, 97, 8, DATE '2026-02-16', 'Completed');
INSERT INTO class_enrollment VALUES (145, 43, 12, DATE '2026-05-25', 'Enrolled');
INSERT INTO class_enrollment VALUES (146, 83, 8, DATE '2026-07-26', 'Enrolled');
INSERT INTO class_enrollment VALUES (147, 101, 9, DATE '2026-08-06', 'Enrolled');
INSERT INTO class_enrollment VALUES (148, 118, 2, DATE '2026-09-15', 'Enrolled');
INSERT INTO class_enrollment VALUES (149, 79, 12, DATE '2026-05-31', 'Completed');
INSERT INTO class_enrollment VALUES (150, 84, 4, DATE '2026-03-05', 'Enrolled');

INSERT INTO payment VALUES (1, 18, 5000, DATE '2026-01-13', 'Cash', 'Paid');
INSERT INTO payment VALUES (2, 23, 13500, DATE '2025-11-18', 'Card', 'Pending');
INSERT INTO payment VALUES (3, 89, 45000, DATE '2026-07-29', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (4, 40, 45000, DATE '2026-01-19', 'Card', 'Paid');
INSERT INTO payment VALUES (5, 81, 5000, DATE '2026-04-05', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (6, 24, 13500, DATE '2026-04-27', 'Card', 'Pending');
INSERT INTO payment VALUES (7, 11, 25000, DATE '2025-11-09', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (8, 32, 25000, DATE '2026-06-24', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (9, 10, 45000, DATE '2026-10-18', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (10, 110, 5000, DATE '2026-04-16', 'Card', 'Paid');
INSERT INTO payment VALUES (11, 100, 13500, DATE '2026-11-01', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (12, 115, 5000, DATE '2026-08-25', 'Card', 'Paid');
INSERT INTO payment VALUES (13, 96, 25000, DATE '2026-11-05', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (14, 85, 13500, DATE '2026-07-28', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (15, 69, 25000, DATE '2026-09-15', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (16, 10, 45000, DATE '2026-10-19', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (17, 51, 45000, DATE '2026-09-18', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (18, 4, 45000, DATE '2025-12-13', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (19, 119, 5000, DATE '2026-10-09', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (20, 75, 25000, DATE '2026-06-04', 'Cash', 'Paid');
INSERT INTO payment VALUES (21, 31, 25000, DATE '2026-04-17', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (22, 35, 5000, DATE '2026-08-14', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (23, 118, 5000, DATE '2026-08-28', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (24, 76, 5000, DATE '2026-05-25', 'Cash', 'Paid');
INSERT INTO payment VALUES (25, 2, 13500, DATE '2026-07-28', 'Card', 'Paid');
INSERT INTO payment VALUES (26, 105, 25000, DATE '2026-07-04', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (27, 87, 13500, DATE '2026-09-27', 'Card', 'Paid');
INSERT INTO payment VALUES (28, 40, 45000, DATE '2026-01-19', 'Cash', 'Pending');
INSERT INTO payment VALUES (29, 66, 25000, DATE '2026-07-03', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (30, 1, 13500, DATE '2026-06-23', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (31, 113, 45000, DATE '2026-01-30', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (32, 34, 13500, DATE '2026-11-09', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (33, 33, 13500, DATE '2025-11-11', 'Card', 'Pending');
INSERT INTO payment VALUES (34, 84, 5000, DATE '2026-03-04', 'Card', 'Paid');
INSERT INTO payment VALUES (35, 82, 13500, DATE '2026-05-21', 'Card', 'Paid');
INSERT INTO payment VALUES (36, 13, 25000, DATE '2026-11-16', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (37, 72, 5000, DATE '2026-02-16', 'Cash', 'Paid');
INSERT INTO payment VALUES (38, 102, 5000, DATE '2025-11-04', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (39, 38, 45000, DATE '2026-02-15', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (40, 109, 5000, DATE '2026-07-16', 'Card', 'Paid');
INSERT INTO payment VALUES (41, 27, 45000, DATE '2026-11-05', 'Cash', 'Pending');
INSERT INTO payment VALUES (42, 100, 13500, DATE '2026-10-31', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (43, 64, 13500, DATE '2025-12-25', 'Cash', 'Paid');
INSERT INTO payment VALUES (44, 86, 45000, DATE '2026-01-04', 'Cash', 'Paid');
INSERT INTO payment VALUES (45, 56, 13500, DATE '2026-01-21', 'Card', 'Paid');
INSERT INTO payment VALUES (46, 30, 5000, DATE '2026-02-20', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (47, 90, 13500, DATE '2026-10-18', 'Cash', 'Paid');
INSERT INTO payment VALUES (48, 25, 5000, DATE '2026-07-06', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (49, 8, 25000, DATE '2026-01-06', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (50, 68, 13500, DATE '2026-09-29', 'Cash', 'Paid');
INSERT INTO payment VALUES (51, 43, 5000, DATE '2026-05-10', 'Card', 'Paid');
INSERT INTO payment VALUES (52, 60, 13500, DATE '2026-04-03', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (53, 44, 13500, DATE '2026-07-23', 'Cash', 'Paid');
INSERT INTO payment VALUES (54, 49, 5000, DATE '2025-11-08', 'Cash', 'Paid');
INSERT INTO payment VALUES (55, 54, 45000, DATE '2026-04-28', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (56, 36, 5000, DATE '2026-06-22', 'Card', 'Paid');
INSERT INTO payment VALUES (57, 57, 45000, DATE '2026-08-08', 'Card', 'Paid');
INSERT INTO payment VALUES (58, 3, 5000, DATE '2026-06-04', 'Card', 'Paid');
INSERT INTO payment VALUES (59, 13, 25000, DATE '2026-11-16', 'Card', 'Paid');
INSERT INTO payment VALUES (60, 58, 5000, DATE '2025-12-15', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (61, 87, 13500, DATE '2026-09-30', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (62, 120, 5000, DATE '2025-11-23', 'Cash', 'Paid');
INSERT INTO payment VALUES (63, 103, 5000, DATE '2026-02-16', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (64, 20, 5000, DATE '2026-07-30', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (65, 16, 45000, DATE '2026-09-11', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (66, 46, 25000, DATE '2026-06-06', 'Cash', 'Pending');
INSERT INTO payment VALUES (67, 111, 5000, DATE '2026-05-28', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (68, 9, 13500, DATE '2026-08-11', 'Card', 'Paid');
INSERT INTO payment VALUES (69, 97, 13500, DATE '2026-02-14', 'Cash', 'Paid');
INSERT INTO payment VALUES (70, 77, 5000, DATE '2026-05-19', 'Cash', 'Paid');
INSERT INTO payment VALUES (71, 88, 25000, DATE '2026-07-01', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (72, 28, 5000, DATE '2026-06-28', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (73, 111, 5000, DATE '2026-05-28', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (74, 20, 5000, DATE '2026-07-30', 'Card', 'Paid');
INSERT INTO payment VALUES (75, 61, 25000, DATE '2026-11-04', 'Cash', 'Paid');
INSERT INTO payment VALUES (76, 91, 13500, DATE '2026-07-31', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (77, 84, 5000, DATE '2026-03-03', 'Card', 'Paid');
INSERT INTO payment VALUES (78, 29, 13500, DATE '2025-11-13', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (79, 98, 5000, DATE '2026-04-03', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (80, 27, 45000, DATE '2026-11-05', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (81, 108, 5000, DATE '2026-07-05', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (82, 93, 45000, DATE '2026-03-23', 'Easypaisa', 'Pending');
INSERT INTO payment VALUES (83, 82, 13500, DATE '2026-05-21', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (84, 78, 45000, DATE '2026-03-24', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (85, 77, 5000, DATE '2026-05-19', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (86, 115, 5000, DATE '2026-08-25', 'Easypaisa', 'Pending');
INSERT INTO payment VALUES (87, 62, 13500, DATE '2026-10-26', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (88, 6, 5000, DATE '2026-11-10', 'Cash', 'Paid');
INSERT INTO payment VALUES (89, 116, 13500, DATE '2026-02-27', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (90, 39, 5000, DATE '2026-03-05', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (91, 26, 5000, DATE '2026-10-07', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (92, 63, 45000, DATE '2026-10-18', 'Card', 'Paid');
INSERT INTO payment VALUES (93, 50, 5000, DATE '2026-10-31', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (94, 71, 45000, DATE '2025-11-09', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (95, 9, 13500, DATE '2026-08-09', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (96, 85, 13500, DATE '2026-07-30', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (97, 67, 13500, DATE '2026-06-24', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (98, 117, 45000, DATE '2026-02-27', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (99, 37, 45000, DATE '2026-09-09', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (100, 45, 25000, DATE '2025-12-25', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (101, 42, 13500, DATE '2026-07-23', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (102, 22, 13500, DATE '2026-02-08', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (103, 65, 5000, DATE '2026-03-17', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (104, 95, 25000, DATE '2026-06-06', 'Card', 'Paid');
INSERT INTO payment VALUES (105, 48, 5000, DATE '2026-03-16', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (106, 64, 13500, DATE '2025-12-26', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (107, 94, 5000, DATE '2026-05-31', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (108, 117, 45000, DATE '2026-03-01', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (109, 80, 45000, DATE '2026-05-31', 'Card', 'Paid');
INSERT INTO payment VALUES (110, 48, 5000, DATE '2026-03-16', 'Card', 'Paid');
INSERT INTO payment VALUES (111, 83, 45000, DATE '2026-07-14', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (112, 19, 5000, DATE '2025-11-12', 'Card', 'Paid');
INSERT INTO payment VALUES (113, 71, 45000, DATE '2025-11-09', 'Card', 'Paid');
INSERT INTO payment VALUES (114, 7, 5000, DATE '2026-06-26', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (115, 53, 25000, DATE '2026-10-02', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (116, 17, 13500, DATE '2026-07-01', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (117, 21, 13500, DATE '2026-02-26', 'Easypaisa', 'Pending');
INSERT INTO payment VALUES (118, 99, 45000, DATE '2025-12-01', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (119, 59, 25000, DATE '2025-12-19', 'Easypaisa', 'Pending');
INSERT INTO payment VALUES (120, 47, 5000, DATE '2025-12-02', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (121, 114, 5000, DATE '2026-03-18', 'Card', 'Paid');
INSERT INTO payment VALUES (122, 74, 45000, DATE '2026-07-10', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (123, 52, 5000, DATE '2026-11-14', 'Card', 'Paid');
INSERT INTO payment VALUES (124, 12, 5000, DATE '2026-08-02', 'Card', 'Paid');
INSERT INTO payment VALUES (125, 106, 13500, DATE '2025-12-05', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (126, 15, 5000, DATE '2026-09-04', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (127, 55, 5000, DATE '2025-12-17', 'Card', 'Paid');
INSERT INTO payment VALUES (128, 41, 25000, DATE '2025-12-22', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (129, 112, 45000, DATE '2025-12-10', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (130, 2, 13500, DATE '2026-07-28', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (131, 53, 25000, DATE '2026-10-02', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (132, 104, 25000, DATE '2026-02-09', 'Cash', 'Paid');
INSERT INTO payment VALUES (133, 101, 25000, DATE '2026-07-28', 'Card', 'Paid');
INSERT INTO payment VALUES (134, 51, 45000, DATE '2026-09-19', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (135, 94, 5000, DATE '2026-06-02', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (136, 5, 13500, DATE '2026-06-25', 'Bank Transfer', 'Pending');
INSERT INTO payment VALUES (137, 5, 13500, DATE '2026-06-24', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (138, 62, 13500, DATE '2026-10-28', 'Card', 'Paid');
INSERT INTO payment VALUES (139, 92, 45000, DATE '2026-02-08', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (140, 80, 45000, DATE '2026-05-30', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (141, 14, 13500, DATE '2026-05-25', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (142, 107, 5000, DATE '2026-09-15', 'Cash', 'Pending');
INSERT INTO payment VALUES (143, 79, 5000, DATE '2026-05-14', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (144, 73, 45000, DATE '2026-01-09', 'Bank Transfer', 'Paid');
INSERT INTO payment VALUES (145, 105, 25000, DATE '2026-07-02', 'JazzCash', 'Paid');
INSERT INTO payment VALUES (146, 70, 5000, DATE '2026-02-21', 'Easypaisa', 'Paid');
INSERT INTO payment VALUES (147, 102, 5000, DATE '2025-11-03', 'Card', 'Paid');
INSERT INTO payment VALUES (148, 42, 13500, DATE '2026-07-22', 'Card', 'Paid');
INSERT INTO payment VALUES (149, 24, 13500, DATE '2026-04-27', 'Card', 'Paid');
INSERT INTO payment VALUES (150, 116, 13500, DATE '2026-03-02', 'Easypaisa', 'Paid');

INSERT INTO attendance VALUES (1, 98, DATE '2026-04-18', '08:45', '10:15');
INSERT INTO attendance VALUES (2, 101, DATE '2026-11-12', '09:30', '11:15');
INSERT INTO attendance VALUES (3, 88, DATE '2026-09-03', '18:15', '20:00');
INSERT INTO attendance VALUES (4, 1, DATE '2026-09-21', '10:30', '11:45');
INSERT INTO attendance VALUES (5, 84, DATE '2026-03-22', '17:45', '19:30');
INSERT INTO attendance VALUES (6, 55, DATE '2025-12-19', '17:15', '18:45');
INSERT INTO attendance VALUES (7, 110, DATE '2026-04-25', '06:00', '08:00');
INSERT INTO attendance VALUES (8, 116, DATE '2026-04-09', '08:30', '10:30');
INSERT INTO attendance VALUES (9, 2, DATE '2026-10-19', '06:15', '07:15');
INSERT INTO attendance VALUES (10, 84, DATE '2026-03-21', '10:00', '12:00');
INSERT INTO attendance VALUES (11, 19, DATE '2025-12-09', '09:15', '11:00');
INSERT INTO attendance VALUES (12, 45, DATE '2026-02-01', '09:45', '11:45');
INSERT INTO attendance VALUES (13, 22, DATE '2026-04-27', '07:30', '08:45');
INSERT INTO attendance VALUES (14, 64, DATE '2026-03-22', '09:00', '10:45');
INSERT INTO attendance VALUES (15, 86, DATE '2026-03-04', '20:00', '21:30');
INSERT INTO attendance VALUES (16, 54, DATE '2026-06-23', '08:45', '10:30');
INSERT INTO attendance VALUES (17, 72, DATE '2026-02-17', '19:45', '21:00');
INSERT INTO attendance VALUES (18, 90, DATE '2026-11-16', '09:45', '11:00');
INSERT INTO attendance VALUES (19, 70, DATE '2026-03-11', '06:15', '07:45');
INSERT INTO attendance VALUES (20, 60, DATE '2026-07-01', '19:30', '21:15');
INSERT INTO attendance VALUES (21, 48, DATE '2026-04-10', '18:00', '19:15');
INSERT INTO attendance VALUES (22, 82, DATE '2026-07-06', '06:00', '08:00');
INSERT INTO attendance VALUES (23, 6, DATE '2026-11-20', '17:00', '19:00');
INSERT INTO attendance VALUES (24, 62, DATE '2026-11-09', '08:00', '09:15');
INSERT INTO attendance VALUES (25, 92, DATE '2026-09-07', '08:30', '09:30');
INSERT INTO attendance VALUES (26, 111, DATE '2026-06-20', '17:45', '19:45');
INSERT INTO attendance VALUES (27, 71, DATE '2026-02-24', '10:45', '12:15');
INSERT INTO attendance VALUES (28, 55, DATE '2025-12-30', '20:00', '21:30');
INSERT INTO attendance VALUES (29, 38, DATE '2026-08-12', '19:45', '21:15');
INSERT INTO attendance VALUES (30, 65, DATE '2026-04-02', '20:30', '21:45');
INSERT INTO attendance VALUES (31, 84, DATE '2026-04-03', '07:30', '08:45');
INSERT INTO attendance VALUES (32, 41, DATE '2026-06-19', '10:15', '12:15');
INSERT INTO attendance VALUES (33, 82, DATE '2026-06-01', '06:45', '08:45');
INSERT INTO attendance VALUES (34, 114, DATE '2026-04-12', '20:00', '21:45');
INSERT INTO attendance VALUES (35, 39, DATE '2026-03-10', '06:00', '07:15');
INSERT INTO attendance VALUES (36, 106, DATE '2026-01-31', '06:45', '08:45');
INSERT INTO attendance VALUES (37, 19, DATE '2025-12-02', '07:15', '08:15');
INSERT INTO attendance VALUES (38, 86, DATE '2026-08-26', '08:00', '09:15');
INSERT INTO attendance VALUES (39, 112, DATE '2025-12-25', '18:00', '19:00');
INSERT INTO attendance VALUES (40, 48, DATE '2026-03-22', '10:30', '12:00');
INSERT INTO attendance VALUES (41, 24, DATE '2026-06-18', '06:30', '07:30');
INSERT INTO attendance VALUES (42, 56, DATE '2026-04-02', '06:45', '08:45');
INSERT INTO attendance VALUES (43, 67, DATE '2026-06-29', '07:45', '09:45');
INSERT INTO attendance VALUES (44, 90, DATE '2026-11-10', '19:00', '20:00');
INSERT INTO attendance VALUES (45, 88, DATE '2026-10-08', '08:45', '10:30');
INSERT INTO attendance VALUES (46, 71, DATE '2025-12-31', '07:45', '09:00');
INSERT INTO attendance VALUES (47, 115, DATE '2026-09-02', '06:45', '07:45');
INSERT INTO attendance VALUES (48, 2, DATE '2026-10-22', '07:00', '08:15');
INSERT INTO attendance VALUES (49, 112, DATE '2026-02-07', '08:45', '09:45');
INSERT INTO attendance VALUES (50, 36, DATE '2026-07-13', '09:45', '11:00');
INSERT INTO attendance VALUES (51, 119, DATE '2026-10-10', '17:15', '18:15');
INSERT INTO attendance VALUES (52, 38, DATE '2026-10-25', '19:30', '20:30');
INSERT INTO attendance VALUES (53, 92, DATE '2026-02-23', '06:00', '07:00');
INSERT INTO attendance VALUES (54, 114, DATE '2026-03-23', '18:30', '20:00');
INSERT INTO attendance VALUES (55, 94, DATE '2026-06-09', '19:00', '20:30');
INSERT INTO attendance VALUES (56, 48, DATE '2026-04-11', '19:15', '20:30');
INSERT INTO attendance VALUES (57, 103, DATE '2026-02-18', '17:15', '19:00');
INSERT INTO attendance VALUES (58, 62, DATE '2026-11-06', '19:30', '21:30');
INSERT INTO attendance VALUES (59, 43, DATE '2026-05-25', '10:00', '12:00');
INSERT INTO attendance VALUES (60, 84, DATE '2026-03-24', '06:15', '08:15');
INSERT INTO attendance VALUES (61, 107, DATE '2026-09-21', '18:15', '20:00');
INSERT INTO attendance VALUES (62, 50, DATE '2026-11-20', '18:15', '20:00');
INSERT INTO attendance VALUES (63, 37, DATE '2026-09-07', '17:30', '19:00');
INSERT INTO attendance VALUES (64, 55, DATE '2025-12-24', '06:30', '07:45');
INSERT INTO attendance VALUES (65, 104, DATE '2026-07-05', '08:30', '10:30');
INSERT INTO attendance VALUES (66, 88, DATE '2026-11-05', '17:00', '19:00');
INSERT INTO attendance VALUES (67, 71, DATE '2026-07-15', '18:15', '19:30');
INSERT INTO attendance VALUES (68, 40, DATE '2026-02-17', '18:45', '20:00');
INSERT INTO attendance VALUES (69, 119, DATE '2026-10-23', '06:45', '08:30');
INSERT INTO attendance VALUES (70, 70, DATE '2026-02-22', '20:30', '21:30');
INSERT INTO attendance VALUES (71, 30, DATE '2026-03-01', '20:30', '22:30');
INSERT INTO attendance VALUES (72, 42, DATE '2026-09-21', '20:15', '21:30');
INSERT INTO attendance VALUES (73, 28, DATE '2026-07-03', '07:15', '08:45');
INSERT INTO attendance VALUES (74, 47, DATE '2025-12-18', '17:45', '19:45');
INSERT INTO attendance VALUES (75, 110, DATE '2026-04-17', '09:00', '10:45');
INSERT INTO attendance VALUES (76, 48, DATE '2026-03-20', '17:45', '18:45');
INSERT INTO attendance VALUES (77, 20, DATE '2026-08-18', '06:30', '08:00');
INSERT INTO attendance VALUES (78, 67, DATE '2026-09-09', '06:00', '07:00');
INSERT INTO attendance VALUES (79, 27, DATE '2026-11-23', '19:15', '20:45');
INSERT INTO attendance VALUES (80, 119, DATE '2026-10-24', '18:00', '19:45');
INSERT INTO attendance VALUES (81, 99, DATE '2026-09-27', '08:30', '09:30');
INSERT INTO attendance VALUES (82, 44, DATE '2026-08-17', '08:45', '09:45');
INSERT INTO attendance VALUES (83, 4, DATE '2026-01-05', '06:30', '08:15');
INSERT INTO attendance VALUES (84, 63, DATE '2026-10-20', '18:00', '19:00');
INSERT INTO attendance VALUES (85, 33, DATE '2025-12-20', '09:00', '11:00');
INSERT INTO attendance VALUES (86, 51, DATE '2026-10-11', '19:15', '20:45');
INSERT INTO attendance VALUES (87, 31, DATE '2026-06-11', '08:00', '09:30');
INSERT INTO attendance VALUES (88, 46, DATE '2026-06-20', '20:00', '21:00');
INSERT INTO attendance VALUES (89, 34, DATE '2026-11-23', '19:00', '20:00');
INSERT INTO attendance VALUES (90, 19, DATE '2025-11-22', '06:15', '07:45');
INSERT INTO attendance VALUES (91, 76, DATE '2026-06-20', '07:45', '09:15');
INSERT INTO attendance VALUES (92, 48, DATE '2026-03-30', '18:00', '19:30');
INSERT INTO attendance VALUES (93, 62, DATE '2026-11-06', '08:45', '10:00');
INSERT INTO attendance VALUES (94, 104, DATE '2026-03-17', '06:45', '08:00');
INSERT INTO attendance VALUES (95, 103, DATE '2026-02-16', '08:15', '09:15');
INSERT INTO attendance VALUES (96, 120, DATE '2025-12-12', '17:15', '19:00');
INSERT INTO attendance VALUES (97, 13, DATE '2026-11-20', '06:00', '07:45');
INSERT INTO attendance VALUES (98, 44, DATE '2026-09-02', '09:45', '10:45');
INSERT INTO attendance VALUES (99, 81, DATE '2026-04-13', '08:30', '09:45');
INSERT INTO attendance VALUES (100, 95, DATE '2026-06-18', '08:45', '10:45');
INSERT INTO attendance VALUES (101, 114, DATE '2026-03-27', '19:15', '20:45');
INSERT INTO attendance VALUES (102, 54, DATE '2026-08-08', '09:15', '10:15');
INSERT INTO attendance VALUES (103, 35, DATE '2026-09-01', '17:15', '18:45');
INSERT INTO attendance VALUES (104, 63, DATE '2026-10-22', '17:45', '19:30');
INSERT INTO attendance VALUES (105, 15, DATE '2026-09-08', '20:00', '21:15');
INSERT INTO attendance VALUES (106, 72, DATE '2026-03-03', '10:00', '11:30');
INSERT INTO attendance VALUES (107, 97, DATE '2026-03-11', '17:45', '19:15');
INSERT INTO attendance VALUES (108, 31, DATE '2026-06-15', '07:45', '09:15');
INSERT INTO attendance VALUES (109, 54, DATE '2026-06-05', '06:30', '07:45');
INSERT INTO attendance VALUES (110, 82, DATE '2026-05-23', '19:30', '21:30');
INSERT INTO attendance VALUES (111, 18, DATE '2026-02-10', '06:30', '07:45');
INSERT INTO attendance VALUES (112, 47, DATE '2025-12-13', '06:45', '08:00');
INSERT INTO attendance VALUES (113, 36, DATE '2026-07-08', '08:15', '09:30');
INSERT INTO attendance VALUES (114, 67, DATE '2026-07-23', '08:15', '10:15');
INSERT INTO attendance VALUES (115, 11, DATE '2025-11-29', '19:30', '20:45');
INSERT INTO attendance VALUES (116, 27, DATE '2026-11-09', '09:30', '10:45');
INSERT INTO attendance VALUES (117, 2, DATE '2026-08-04', '20:45', '21:45');
INSERT INTO attendance VALUES (118, 67, DATE '2026-08-07', '17:30', '19:15');
INSERT INTO attendance VALUES (119, 12, DATE '2026-08-01', '18:45', '20:00');
INSERT INTO attendance VALUES (120, 112, DATE '2026-11-12', '10:15', '11:30');
INSERT INTO attendance VALUES (121, 73, DATE '2026-07-13', '06:15', '07:45');
INSERT INTO attendance VALUES (122, 74, DATE '2026-07-08', '17:45', '19:45');
INSERT INTO attendance VALUES (123, 10, DATE '2026-10-23', '17:15', '18:45');
INSERT INTO attendance VALUES (124, 100, DATE '2026-11-22', '18:00', '19:30');
INSERT INTO attendance VALUES (125, 112, DATE '2026-01-31', '19:45', '21:45');
INSERT INTO attendance VALUES (126, 4, DATE '2026-09-07', '20:15', '21:15');
INSERT INTO attendance VALUES (127, 32, DATE '2026-07-15', '09:15', '10:30');
INSERT INTO attendance VALUES (128, 14, DATE '2026-07-03', '10:00', '11:00');
INSERT INTO attendance VALUES (129, 13, DATE '2026-11-17', '10:00', '12:00');
INSERT INTO attendance VALUES (130, 82, DATE '2026-08-02', '19:15', '21:00');
INSERT INTO attendance VALUES (131, 14, DATE '2026-07-08', '07:15', '08:15');
INSERT INTO attendance VALUES (132, 35, DATE '2026-08-21', '19:45', '21:45');
INSERT INTO attendance VALUES (133, 65, DATE '2026-04-02', '07:00', '08:00');
INSERT INTO attendance VALUES (134, 52, DATE '2026-11-13', '20:15', '21:30');
INSERT INTO attendance VALUES (135, 19, DATE '2025-12-03', '19:45', '21:00');
INSERT INTO attendance VALUES (136, 106, DATE '2025-12-04', '18:45', '20:45');
INSERT INTO attendance VALUES (137, 108, DATE '2026-07-04', '18:00', '19:30');
INSERT INTO attendance VALUES (138, 44, DATE '2026-09-12', '09:30', '11:15');
INSERT INTO attendance VALUES (139, 108, DATE '2026-07-22', '18:00', '19:30');
INSERT INTO attendance VALUES (140, 67, DATE '2026-07-12', '17:15', '19:00');
INSERT INTO attendance VALUES (141, 85, DATE '2026-10-15', '06:30', '07:30');
INSERT INTO attendance VALUES (142, 68, DATE '2026-10-07', '07:30', '09:15');
INSERT INTO attendance VALUES (143, 26, DATE '2026-10-06', '09:15', '11:00');
INSERT INTO attendance VALUES (144, 51, DATE '2026-11-15', '06:00', '07:00');
INSERT INTO attendance VALUES (145, 111, DATE '2026-06-14', '10:00', '12:00');
INSERT INTO attendance VALUES (146, 13, DATE '2026-11-18', '07:00', '08:45');
INSERT INTO attendance VALUES (147, 31, DATE '2026-04-26', '10:00', '11:30');
INSERT INTO attendance VALUES (148, 45, DATE '2026-06-07', '08:00', '09:00');
INSERT INTO attendance VALUES (149, 77, DATE '2026-06-05', '07:45', '09:45');
INSERT INTO attendance VALUES (150, 69, DATE '2026-10-03', '19:00', '21:00');

COMMIT;

SELECT 'MEMBER' AS table_name, COUNT(*) AS total FROM member
UNION ALL SELECT 'PAYMENT', COUNT(*) FROM payment
UNION ALL SELECT 'ATTENDANCE', COUNT(*) FROM attendance
UNION ALL SELECT 'CLASS_ENROLLMENT', COUNT(*) FROM class_enrollment;

SELECT m.member_id, m.full_name, p.plan_name, m.status
FROM member m JOIN membership_plan p ON m.plan_id = p.plan_id;

SELECT g.class_name, t.full_name AS trainer, COUNT(e.member_id) AS members_enrolled
FROM gym_class g
JOIN trainer t ON g.trainer_id = t.trainer_id
LEFT JOIN class_enrollment e ON g.class_id = e.class_id
GROUP BY g.class_name, t.full_name;

SELECT method, SUM(amount) AS total_received
FROM payment WHERE status = 'Paid' GROUP BY method;

SELECT m.full_name, m.phone, p.amount
FROM payment p JOIN member m ON p.member_id = m.member_id
WHERE p.status = 'Pending';
