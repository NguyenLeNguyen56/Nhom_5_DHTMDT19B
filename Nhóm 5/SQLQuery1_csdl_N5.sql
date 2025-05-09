CREATE DATABASE QL_LICH_DAY_GIAO_VIEN;
GO

USE QL_LICH_DAY_GIAO_VIEN;
GO
-- Tạo bảng KHOA
CREATE TABLE KHOA (
    MAKHOA CHAR(5) PRIMARY KEY,
    TENKHOA NVARCHAR(100),
    DTKHOA VARCHAR(15)
);

-- Tạo bảng GIÁO_VIÊN
CREATE TABLE GIAO_VIEN (
    MAGV CHAR(5) PRIMARY KEY,
    HOTEN NVARCHAR(100),
    DTGV VARCHAR(15),
    MAKHOA CHAR(5),
    FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

-- Tạo bảng MÔN_HỌC
CREATE TABLE MON_HOC (
    MAMH CHAR(5) PRIMARY KEY,
    TENMH NVARCHAR(100),
    MAGV CHAR(5),
    FOREIGN KEY (MAGV) REFERENCES GIAO_VIEN(MAGV)
);

-- Tạo bảng PHÒNG_HỌC
CREATE TABLE PHONG_HOC (
    SOPHONG CHAR(5) PRIMARY KEY,
    CHUCNANG NVARCHAR(100)
);

-- Tạo bảng LỚP_HỌC
CREATE TABLE LOP_HOC (
    MALOP CHAR(5) PRIMARY KEY,
    TENLOP NVARCHAR(100),
    SISO INT,
    MAKHOA CHAR(5),
    FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

-- Tạo bảng LỊCH_DẠY
CREATE TABLE LICH_DAY (
    MAGV CHAR(5),
    MALOP CHAR(5),
    MAMH CHAR(5),
    NGAYDAY DATE,
    SOPHONG CHAR(5),
    TUTIET INT,
    DENTIET INT,
    BAIDAY NVARCHAR(100),
    GHICHU NVARCHAR(255),
    LYTHUYET INT,
    PRIMARY KEY (MAGV, MALOP, MAMH, NGAYDAY, TUTIET),
    FOREIGN KEY (MAGV) REFERENCES GIAO_VIEN(MAGV),
    FOREIGN KEY (MALOP) REFERENCES LOP_HOC(MALOP),
    FOREIGN KEY (MAMH) REFERENCES MON_HOC(MAMH),
    FOREIGN KEY (SOPHONG) REFERENCES PHONG_HOC(SOPHONG)
);
-- KHOA
INSERT INTO KHOA VALUES
('KH01', N'Công nghệ thông tin', '0123456789'),
('KH02', N'Kinh tế', '0223456789'),
('KH03', N'Ngôn ngữ', '0323456789'),
('KH04', N'Kinh tế', '0423456789'),
('KH05', N'Kinh tế', '0523456789');

-- GIAO VIEN
INSERT INTO GIAO_VIEN VALUES
('GV01', N'Nguyễn Văn A', '0912345678', 'KH01'),
('GV02', N'Trần Thị B', '0922345678', 'KH01'),
('GV03', N'Lê Văn C', '0932345678', 'KH02'),
('GV04', N'Phạm Thị D', '0942345678', 'KH03'),
('GV05', N'Hoàng Văn E', '0952345678', 'KH04');

-- MON HOC
INSERT INTO MON_HOC VALUES
('MH01', N'Lập trình C', 'GV01'),
('MH02', N'Cơ sở lý thuyết', 'GV03'),
('MH03', N'Kinh tế vi mô', 'GV05'),
('MH04', N'Ngữ pháp tiếng Việt', 'GV05'),
('MH05', N'Điện tử công suất', 'GV04');
-- PHONG HOC
INSERT INTO PHONG_HOC VALUES
('PH01', N'Phòng lý thuyết'),
('PH02', N'Phòng thực hành máy tính'),
('PH03', N'Phòng nghe nhìn'),
('PH04', N'Xưởng cơ khí'),
('PH05', N'Phòng thí nghiệm');

-- LOP HOC
INSERT INTO LOP_HOC VALUES
('LP01', N'CNTT - K14', 40, 'KH01'),
('LP02', N'Cơ khí - K12', 35, 'KH02'),
('LP03', N'Điện tử - K13', 38, 'KH03'),
('LP04', N'Kinh tế - K15', 50, 'KH04'),
('LP05', N'Ngữ văn - K14', 45, 'KH05');

-- LICH DAY
INSERT INTO LICH_DAY (MAGV, MALOP, MAMH, NGAYDAY, SOPHONG, TUTIET, DENTIET, BAIDAY, GHICHU, LYTHUYET)
VALUES
('GV01', 'LP01', 'MH01', '2025-05-05', 'PH02', 1, 2, N'Cấu trúc rẽ nhánh', N'', 1),
('GV03', 'LP02', 'MH02', '2025-05-06', 'PH03', 1, 2, N'Chương 1 - Cơ học', N'Mang tài liệu', 2),
('GV05', 'LP04', 'MH03', '2025-05-06', 'PH05', 1, 2, N'Tổng quan kinh tế', N'', 2),
('GV05', 'LP05', 'MH04', '2025-05-07', 'PH04', 2, 3, N'Ngữ pháp căn bản', N'', 2),
('GV03', 'LP03', 'MH05', '2025-05-08', 'PH05', 10, 11, N'Điện áp 3 pha', N'Mang đồng hồ đo', 1);

SELECT * FROM KHOA;
SELECT * FROM GIAO_VIEN;
SELECT * FROM MON_HOC;
SELECT * FROM PHONG_HOC;
SELECT * FROM LOP_HOC;
SELECT * FROM LICH_DAY;

--4. Tự cho câu hỏi và trả lời: 12 câu (2 truy vấn kết nối nhiều bảng, 2 update, 2 delete, 2 group by, 2 sub query, 2 câu bất kì) – xem ví dụ tại bài tập 1
--I.Truy vấn Join
--Câu hỏi: Liệt kê mã giáo viên, họ tên, và tổng số tiết giảng dạy thực tế, chỉ hiển thị những giáo viên đã dạy từ 6 tiết trở lên trong tất cả các lịch dạy.
SELECT GV.MAGV, 
       GV.HOTEN, 
       SUM(LD.DENTIET - LD.TUTIET + 1) AS TONG_SOTIET_DAY
FROM LICH_DAY LD
JOIN GIAO_VIEN GV ON LD.MAGV = GV.MAGV
GROUP BY GV.MAGV, GV.HOTEN
HAVING SUM(LD.DENTIET - LD.TUTIET + 1) >= 6;

--Câu 2: Tìm tên các giáo viên thuộc khoa "Công nghệ thông tin" và môn học mà họ đang giảng dạy.

SELECT   GV.HOTEN, MH.TENMH
FROM GIAO_VIEN GV
JOIN MON_HOC MH ON GV.MAGV = MH.MAGV
JOIN KHOA K ON GV.MAKHOA = K.MAKHOA
WHERE K.TENKHOA = N'Công nghệ thông tin';
--II. Truy Vấn Update
--Câu 1: Cập nhật nội dung ghi chú (GHICHU) trong bảng LICH_DAY thành 'Mang giáo án' cho các buổi học bắt đầu từ tiết 1 và kết thúc ở tiết 2.
UPDATE LICH_DAY
SET GHICHU = N'Mang giáo án'
WHERE TUTIET = 1 AND DENTIET = 2;
--Câu 2: Cập nhật số điện thoại cho giáo viên có tên là "Trần Văn An"
UPDATE GIAO_VIEN
SET DTGV = '0912345678'
WHERE HOTEN = 'TRẦN VĂN AN';
--III. Truy vấn DELETE
--Câu 1: Xóa tất cả các lịch dạy diễn ra vào ngày '2025-05-05':
DELETE FROM LICH_DAY
WHERE NGAYDAY = '2025-05-05'
--Câu 2: Xóa tất cả các giáo viên thuộc khoa 'Cơ khí' ('KH02') và không có bất kỳ môn học nào được gán cho họ trong bảng MON_HOC:
DELETE FROM GIAO_VIEN
WHERE MAKHOA = 'KH02'
  AND MAGV NOT IN (SELECT MAGV FROM MON_HOC);
--IV. 2 truy vấn GROUP BY
--Câu 1. Thống kê số lượng lớp của từng khoa
 SELECT MAKHOA, COUNT(*) AS SoLuongLop
FROM LOP_HOC
GROUP BY MAKHOA;
--Câu 2. Thống kê số môn học do từng giáo viên giảng dạy
SELECT MAGV, COUNT(*) AS SoLuongMonHoc
FROM MON_HOC
GROUP BY MAGV;

--V. 2 CÂU SUBQUERY(TRUY VẤN CON)
--Câu 1 Tìm tên các lớp học có số tiết lý thuyết trong lịch dạy cao hơn số tiết lý thuyết trung bình của tất cả các lớp.
SELECT DISTINCT TENLOP
FROM LOP_HOC
WHERE MALOP IN ( SELECT MALOP
                                     FROM LICH_DAY
                                     GROUP BY MALOP
                                     HAVING SUM(LYTHUYET) > (SELECT AVG(TongLT)
FROM ( SELECT SUM(LYTHUYET) AS TongLT
FROM LICH_DAY
GROUP BY MALOP ) AS LTTB ))
--Câu 2 Tìm tên các giáo viên có dạy ít nhất một lớp thuộc khoa "Kinh tế".
SELECT HOTEN
FROM GIAO_VIEN
WHERE MAGV IN ( SELECT DISTINCT LD.MAGV
                                    FROM LICH_DAY LD
                                    JOIN LOP_HOC LH ON LD.MALOP = LH.MALOP
                                    JOIN KHOA K ON LH.MAKHOA = K.MAKHOA
                                   WHERE K.TENKHOA = 'Kinh tế')
 
--VI. Truy vấn bất kỳ
--Câu 1:  Liệt kê giáo viên có tên bắt đầu bằng "Nguyễn"
SELECT MAGV, HOTEN
FROM GIAO_VIEN
WHERE HOTEN LIKE 'NGUYỄN%';

--Câu 2: Liệt kê tên các giáo viên có dạy ít nhất 2 buổi, kèm theo số buổi dạy, và sắp xếp theo số buổi dạy giảm dần.
SELECT GV.HOTEN AS TenGiaoVien, COUNT(*) AS SoBuoiDay
FROM LICH_DAY LD
JOIN GIAO_VIEN GV ON LD.MAGV = GV.MAGV
GROUP BY GV.HOTEN
HAVING COUNT(*) >= 2
ORDER BY SoBuoiDay DESC



