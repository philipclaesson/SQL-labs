import pgdb
from functools import reduce
from sys import argv

db_model = {"books":"(book_id), title, author_id, subject_id",
    "publishers":"(publisher_id), name, address",
    "authors":"(author_id), last_name, first_name",
    "stock":"(isbn), cost, retail_price, stock",
    "shipments":"(shipment_id), customer_id, isbn, ship_date",
    "customers":"(customer_id), last_name, first_name",
    "editions":"(isbn), book_id, edition, publisher_id, publication_date",
    "subjects":"(subject_id), subject, location"}


class DBContext:
    """DBContext is a small interface to a database that simplifies SQL.
    Each function gathers the minimal amount of information required and executes the query."""

    def __init__(self): #PG-connection setup
        print("AUTHORS NOTE: If you submit faulty information here, I am not responsible for the consequences.")

        params = {'host':'nestor2.csc.kth.se', 'user':'philipcl', 'database':'philipcl', 'password':'1EOnKQNI'}
        self.conn = pgdb.connect(**params)

        self.menu = ["Select.", "Insert.", "Remove.", "Exit"]
        self.cur = self.conn.cursor()

# Here we define a member function that we can later call repeatidly
    def print_menu(self):
        """Prints a menu of all functions this program offers.  Returns the numerical correspondant of the choice made."""
        for i,x in enumerate(self.menu):
            print("%i. %s"%(i+1,x))
            # this get_int function is defined below
        return self.get_int()

    def get_int(self):
        """Retrieves an integer from the user.
        If the user fails to submit an integer, it will reprompt until an integer is submitted."""
        while True:
            try:
                choice = int(input("Choose: "))
                if 1 <= choice <= len(self.menu):
                    return choice
                print("Invalid choice.")
            except (NameError,ValueError, TypeError, SyntaxError):
                print("That was not a number, genious.... :(")

                # This function will be called if the user choses select.
    def select(self):
        """Finds and prints tuples.
        Will query the user for the information required to identify a tuple.
        If the filter field is left blank, no filter will be used."""
        tables = [x.strip() + " natural join " for x in input("Choose table(s): ").split(",")]

        tables[len(tables)-1] = tables[len(tables)-1][0:len(tables[len(tables)-1])-14]
        print (tables)

        columns = input("Choose column(s): ")
        print (columns)
        #list comprehension building a list ready to be reduced into a string.
        filters = input("Apply filters: ")

        try:
            query = """SELECT %s FROM %s%s;"""%(reduce(lambda a,b:a+b,columns), "".join(tables), "" if filters == "" else " WHERE %s"%filters)
            self.cur.execute(query)       

        except (NameError,ValueError, TypeError,SyntaxError):
            print ("  Bad input.")
            return
        print(query)
        # This function is defined below
        self.print_answer()
        #OK now you do the next two:
    def remove(self):
        """Removes tuples.
        Will query the user for the information required to identify a tuple.
        If the filter field is left blank, no filters will be used."""

        table = input("Choose Table:") #Choose table
        print (table)

        column = input("Choose Column: ") #Choose column for condition

        operator = False
        while operator not in ["=", "<", ">"]: #Choose valid operator
            operator = input("Choose Operator =, <, >: ")
        
        value = input("Choose Value: ") #Choose value of column

        try:
            query = "DELETE FROM %s WHERE %s%s%i;" % (table, column, operator, int(value))  #(reduce(lambda a,b:a+b,columns), "".join(tables), "" if filters == "" else " WHERE %s"%filters)
            self.cur.execute(query)       

        except: #(NameError,ValueError,TypeError,SyntaxError):
            print ("  Bad input.")
        print(query)

    def insert(self):
        """inserts tuples.
        Will query the user for the information required to create tuples."""
        pass    
        format = ("INSERT INTO %s VALUES %s;")
        table = input("Choose table (lower case): ")



        values = input("Add values separated by commas on the form "+db_model[table]+": ")

        #Making values into a comma separated string
        values_string = "(" + values +")"
        #query = "INSERT INTO books (book_id, title, author_id, subject_id) VALUES (100, 'boktitel',115, 10);"
        #values_string = "(100, 'boktitel',115, 10);"
        try:
            query = format % (table, values_string)
            #"INSERT INTO "+table+" VALUES " + values_string   %table, values_string #reduce(lambda a,b:a+b,values))
            #print(query)
            self.cur.execute(query)       
        except: #(NameError, ValueError, TypeError, SyntaxError):
            print ("  Bad input.")

       
        return
        #print(query)


    def exit(self):  
        self.cur.close()
        self.conn.close()
        exit()
    
    def print_answer(self):
# We print all the stuff that was just fetched.
            print("\n".join([", ".join([str(a) for a in x]) for x in self.cur.fetchall()]))

    # we call this below in the main function.
    def run(self):
        """Main loop.
        Will divert control through the DBContext as dictated by the user."""
        actions = [self.select, self.insert, self.remove, self.exit]
        while True:
            try:
                # So this is executed right to left, The print_menu
                # function is run first (defined above), then the
                # return value is used as an index into the list
                # actions defined above, then that action is called.
                actions[self.print_menu()-1]()
                print
            except IndexError:
# if somehow the index into actions is wrong we just loop back
                print("Bad choice")

# This strange looking line is what kicks it all off.  So python reads until it sees this then starts executing what comes after-
if __name__ == "__main__":
    db = DBContext()
    db.run()
