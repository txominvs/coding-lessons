// C++ LESSONS

// == Lesson 1 ==

#include <iostream>
std::cout << "Hi" << std::endl;
bool, double, int, unsigned int
double bracket_intialization{ 3.14 };
double initialized_to_ZERO{};
auto type_is_inferred = 3.14;
int truncated_number = static_cast<int>(3.1416);

// == Lesson 2 ==

#include <string>
using namespace std;
using std::string;
std::string something_stringy{ "Hi!" };
#include "Utilities.h"
g++ *.cpp -o output

// == Lesson 3 ==

# pragma once // USED IN HEADER FILES!!!!!!!!!!!!!!!!!!!!!!!!!!!!

class Rectangle
{
public:
	int _width;
	int _height;
};
Rectangle small_rect; small_rect._width = 3; small_rect._height = 4;
Rectangle small_rect{3, 4};
Rectangle initialized_to_ZERO{}; // Rectangle small_rect{0,0};

class Rectangle
{
public:
	// DEFAULT CONSTRUCTOR called by Rectangle uninitialized;
	// ALSO CALED BY Rectangle uninitialized{};
	Rectangle()
		: _width{}, _height{}
	{}

	// CUSTOM CONSTRUCTOR
	Rectangle(int def_width)
		: _width{ def_width }, _height{ 1 }
	{}

	// MEMBER FUNCTION
	int get_area()
	{
		return this->_width * this->_height;
		OR EQUIVALENTLY JUST OMIT "this->"
		return _width * _height;
	}

	// DECLARED BUT DEFINED LATER (used in header files)
	int get_width();
private:
	int _width;
	int _height;
};

// DECLARED BUT DEFINED LATER (used in header files)
int Rectangle::get_width() {
	return _width;
}

class Rectangle
{
public:
	int get_area() const
	{
		return _width * _height
	}
}

Rectangle const small_rect{3, 4};
int area_of_it{ small_rect.get_area() };
// Important to mark get_area() as a CONSTANT function
// that does not change PROPERTIES of the class

// == Lesson 4 ==

int x{1};
int& xref{x}; // Must be initialized
xref = 3; // Assigns 3 to X
int y{xref};
void function_with_side_effects(int& param)
{
	param = param * 2;
}
function_with_side_effects(x) // X gets updated to 2
int const& read_only_ref{x};

// Inheritance
class derived_class : public base_class
{
public:
	derived_class( int init, int ialize, int blabla )
		: base_class{ init, ialize }, _name{ blabla }
	{}
}
derived_class example_class{ "blabla" };
base_class just_inherited_properties{ example_class };
base_class& ref_to_inherited_part{ subclass };

// Polymorphism: how would you write this in C++?
function call_the_area_method(any_shape) {
	return any_shape.area()
}

// the solution is to use POLYMORPHISM
class Shape
{
public:
	virtual int area() const // Can be overwriten later
	{
		cout 	<< "This method can be overwriten"
			<< "by derived SUBclasses.";
		return -1;
	}
	OR
	virtual int area() const = 0; // MUST be defined later
}
class Circle : public Shape
{
public:
	// We define it for every CLASS we consider a "SHAPE"
	int const area() { return pi*radius*radius; }
}
// So that "SHAPE" is a placeholder for any class
// on which we can call ".area()"
int call_the_area_method(const Shape& any_shape)
{
	return any_shape.area()
}
// Keep in mind that since the SHAPE CLASS is a just a placeholder
// class with virtual functions, it cannot be created or initialized
Shape some_abstract_shape{}; // will *NOT* work
// SLICING: References avoid slicing polymorphic objects
class Parent {
public:
	virtual void example()
	{
		cout << "Called from parent!" << endl;
	}
};
class Child : public Parent {
	std::string data_parent_doesnt_have{ "Called from child!" };
public:
	void example()
	{
		cout << "Child says: " << data_parent_doesnt_have << endl;
	}
}
Child child_obj;
Parent slicing_happens_here{ child_obj }; // Child object is casted into parent
slicing_happens_here.example(); // All child-specific data is erased = SLICING!
Parent& refs_avoid_slicing{ child_obj }; // Child-specific members and properties become invisible
refs_avoid_slicing.example(); // Child-specific data is invisible but still exists AND virtual memebers overriden by "Child" are still callable as-is
// These overriden "Child" members provide a way to access child-specific data!

// == LESSON 5 ==

int* pointer_to_x{&variable};
int read_memory{*pointer_to_x};
*pointer_to_x = 2;

// References cannot be changed after initialization
// BUT pointers *CAN* be changed
pointer_to_x = &another_variable;

int* not_initialized_pointer{nullptr};

// THE FREE STORE = the Heap: permanent memory!
// new = ALLOCATE memory in the permanent memory
//       and RETURN A POINTER to its memory location
int* permanent_location{ new int{123} }; // new returns a POINTER!
*permanent_location = 321;
delete p; // free up memory

try
{
	throw std::exception{ "Issues" };
}
catch (const std::exception& e)
{
	std::cout << "Exception: " << e.what();
}

class Rectangle
{
public:
	// COPY constructor is called when
	// Rectangle new_rectangle{old_rectangle}
	Rectangle(Rectangle const& other)
		: _width{other._width}, _height{other._height}
	{ }

	// ASSIGNMENT constructor
	// Returns a REFERENCE just for historical reasons
	// for example in: "x = (y = some rectangle)"
	// and the same object must go into X and Y
	Rectangle& operator=(Rectangle const& other)
	{
		_width = other._width;
		_height = other._height;
		return *this;
		// REMEMBER: "this" is a POINTER so we
		// must derreference it
	}

	// DESTRUCTOR operator: object goes out of scope
	// No parameters => no return (intended for cleanup)
	// Desctructors called in reverse order they were created
	~Rectangle()
	{
		std::count << "Destructing" << _width;
	}

	// DEFAULT (empty) CONSTRUCTOR
	Rectangle()
	{
		std::cout << "Default created!";
	}
}


// RAII: automatic resource management
# include <memory>
std::unique_ptr<Rectangle> pointer_in_heap{ new Rectangle{2, 4} };
// Desctructors for all its properties also get called and destroyed
// for example std::string properties and so on

// std:shared_ptr can be reused multiple times and 
// when its "use count" goes to zero it is automatically destroyed

// == Lesson 6 ==

// Templates: compile time
template<class TEMP>
TEMP add_stuff(TEMP x, TEMP y) { return x + y; }
add_stuff(std::string{"Hello"}, std::string{" World"});
// BEAWARE! "Hello" and std::string{"Hello"} are different

std::vector<double> example_vec{1.1, 5.4, -11.0};
int vec_length{ example_vec.size() };
example.push_back(22);
example_vector[0]++;
// RANGED FOR loops and iterators
for( unsigned int = 0; i < example_vec.size(); ++i) { ... }
for (auto iter = vector.begin(); iter != vector.end(); ++iter) { *iter /*Iterators must be DE-referenced with the asterisk before!*/ }
for (double elem : example_vec) { ... }
for (const auto& elem : example_vec) { ... }
# include <numeric>
# include <algorithm>
accumulate( begin(example_vec), end(example_vec), 0.0/*start val*/ )

vector<int> example_consecutive(100/*size*/);
iota( begin(example_consecutive), end(example_consecutive), 0); // 0, 1, 2, 3, 4...
example_consecutive.erase( begin(example_consecutive) + 23 ); // Remove the element example_consecutive[23]
example_consecutive.erase( begin(example_consecutive) + 13, end(example_consecutive) ); // Remove from example_consecutive[23] till the end
example_consecutive.insert( begin(example_consecutive) + 3, 123456 )
sort( begin(some_vector), end(some_vector) );
auto find_gets_back_iterator = find( begin(v), end(v), "value_to_find" )
*find_gets_back_iterator = "overwrite_value";
double product = accumulate(begin(vec), end(vec), 1.0/*starting value*/,
[](double previous_res, double current_el){return previous_res*current_el;});
auto is_even_lambda = [](int current_el){ return i%2 == 0; } // There is NOT type to store LAMBDA FUNCTIONS, we MUST use the *auto* keyword
int how_many_odds = count_if(
	begin(vect), end(vect),
	is_even_lambda );
copy_if(
	begin(old_vec), end(old_vec),
	begin(new_vec),
	is_even_lambda );
std::generate(v.begin(), v.end(), lambda_to_fill_each_slot);
std::string also_strings{ "Hello World" };
int how_many = count(
	std::begin(also_strings), std::end(also_strings),
	"l");
auto find_returns_iterator = find(
	std::begin(also_strings), std::end(also_strings),
	"W");
char what_we_found{ *find_returns_iterator }; // it stores a "W" char


// == Lesson 7 ==

// > Move semantics, rvalue references
// > Switch, immediate if, comma operator
// > Bitwise operations and shifting
// > Struct
// > Templates
// > Operator overloading
// > C-style arrays/strings, union, printf
// > Macros
// > Running C++ on the GPU (Library AMP)


// Cinder: application maker # include "cinder/app/AppBasic.h"
// Hilo (hilo.codeplex.com) application examples
// isocpp.org : Official Site


















