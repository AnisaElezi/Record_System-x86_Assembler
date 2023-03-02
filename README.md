Assignment:

Write, in 64 bit x86 assembler, a simple record system to help admin keep track of their computers.

Requirements
1. Your system must be able to store the following information about computers:

    ● Computer name
    
    ● IP address
    
    ● OS (can be any one of Linux, Windows, or Mac OSX)
    
    ● User ID of main user
    
    ● Date of purchase
	

2. Your system must be able to store the following information about people:

    ● Surname name
	
    ● First Name
	
    ● Dept (can be any one of Development, IT Support, Finance, or HR)
	
    ● User ID
	
    ● Email address
	
    
3. Your system must allow the following operations:

    ● Add/delete user
	
    ● Add/delete computer
	
    ● Search for computer given a computer name
	
    ● Search for a user’s given a user ID
	
    ● List all users
	
    ● List all computers
	
    
4. You should make the following assumptions about the system:

    ● First names and surnames, all have a maximum size of 64 chars
	
    ● Computer names are unique, and are in the form of cXXXXXXX where XXXXXXX is any 7 digit number
	
    ● User IDs are unique, and are in the form of pXXXXXXX where XXXXXXX is any 7 digit number
	
    ● Email addresses are in the form @helpdesk.co.uk
	
    ● There is a maximum of 100 users and 500 computers on the system

Hints

    ● Take advantage of the limits and the sizes of the computer names and IDs - the  format is chosen for a reason
    ● Think on how you will represent everything - you can either use a very large array  (maybe two) or a smaller array with references to dynamic allocated memory
