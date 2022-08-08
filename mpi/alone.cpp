#include <iostream>
#include <string>



double f(double x) {
	return 4 / (1 + x*x);
}

double Integral(double from, double to, int n) {
	double dx  = (double)1 / n;
	double res = 0;
	for (int i = 0; i < n; ++i) {
		res += (f(i * dx) + f((i + 1) * dx)) / 2 * dx;
	}
	return res;
}


int main(int argc, char *argv[]) {

	int n = std::stoi(argv[1]);

	double res = Integral(0, 1, n);
	std::cout << res << '\n';

	return 0;
}