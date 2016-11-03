#Assignment 0: Getting aquainted with assembly language and the linking process.
Submissions which deviate from the instructions will not be graded!

Please make your output exactly as in the examples below.
Otherwise automatic scripts would fail on your assignment and you will lose some credit for this.
Assignment Description
We provide you with a simple program written in C that receives a string from a user.
Then, this program calls a function written in assembly language (which you need to implement) that receives a (pointer to) a null terminated character string as an argument. Let n be the fourth digit (counting from the right) in the smaller id (of the partners’ ids), if n = 0 then you take the next digit in the id. (1<=n<=9). Your code should operate on the string as follows:

    Add n to each character of the input string to get the result string.
    Count the number of letters in the input string that are converted into a non-letter character in the result string. 


The function returns (a pointer to) the result string and the counter. The characters conversion should be in-place.

Examples (for n=4):

> abcd
> efgh
> 0

> stuvwxyz
> wxyz{|}~
> 4
What We Provide
The attached files:

    main.c As explained above.
    myasm.s Contains skeleton code that you need to modify. 

Submission Instructions
You are to submit a single zip file, ID1_ID2.zip , includes 2 files: main.c and myasm.s.
Do not add new directory structure to the zip file!
Make sure you follow the coding and submission instructions correctly (print exactly as requested).

Good Luck! 
