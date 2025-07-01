-- 1. Scalar subquery in SELECT: Show each member and total loans made by all members
SELECT 
    name,
    (SELECT COUNT(*) FROM Loans) AS total_loans_overall
FROM Members;

-- 2. Subquery in WHERE with IN: Find members who borrowed at least one book
SELECT * FROM Members
WHERE member_id IN (SELECT member_id FROM Loans);

-- 3. Subquery in WHERE with NOT IN: Members who have never borrowed a book
SELECT * FROM Members
WHERE member_id NOT IN (SELECT member_id FROM Loans);

-- 4. Subquery in FROM clause: Average books borrowed per member
SELECT AVG(borrow_count) AS avg_loans
FROM (
    SELECT member_id, COUNT(*) AS borrow_count
    FROM Loans
    GROUP BY member_id
) AS sub;

-- 5. Correlated subquery: Show books that were loaned more than once
SELECT * FROM Books B
WHERE (
    SELECT COUNT(*) FROM Loans L
    WHERE L.book_id = B.book_id
) > 1;

-- 6. Use EXISTS: Find authors who have books in the library
SELECT * FROM Authors A
WHERE EXISTS (
    SELECT 1 FROM Books B WHERE B.author_id = A.author_id
);

-- 7. NOT EXISTS: Find authors with no books
SELECT * FROM Authors A
WHERE NOT EXISTS (
    SELECT 1 FROM Books B WHERE B.author_id = A.author_id
);

-- 8. Subquery to get most borrowed book(s)
SELECT title FROM Books
WHERE book_id = (
    SELECT book_id FROM Loans
    GROUP BY book_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 9. Nested subquery: Get members who borrowed books by 'J.K. Rowling'
SELECT name FROM Members
WHERE member_id IN (
    SELECT member_id FROM Loans
    WHERE book_id IN (
        SELECT book_id FROM Books
        WHERE author_id = (
            SELECT author_id FROM Authors
            WHERE name = 'J.K. Rowling'
        )
    )
);

-- 10. Subquery with aggregate filter: Show members who borrowed more than average number of books
SELECT member_id FROM Loans
GROUP BY member_id
HAVING COUNT(*) > (
    SELECT AVG(loans_per_member) FROM (
        SELECT member_id, COUNT(*) AS loans_per_member
        FROM Loans
        GROUP BY member_id
    ) AS avg_table
);

