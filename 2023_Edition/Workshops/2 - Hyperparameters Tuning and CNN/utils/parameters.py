from sklearn.linear_model import LinearRegression, Ridge
from sklearn.preprocessing import PolynomialFeatures, StandardScaler
import numpy as np

class LinearModel:

    regressor: Ridge
    degree: int

    def __init__(self, degree: int, lambda_: float = 0) -> None:
        if lambda_ == 0:
            self.regressor = LinearRegression()
        else:
            self.regressor = Ridge(alpha=lambda_, random_state=1)

        self.degree = degree
        self.scaler = StandardScaler()
        self.poly = PolynomialFeatures(degree, include_bias=False)

    def fit(self, X, y):
        poly_features = self.poly.fit_transform(X.reshape(-1, 1))
        poly_scaled = self.scaler.fit_transform(poly_features)

        self.regressor.fit(poly_scaled, y)
    
    def predict(self, X):
        poly_features = self.poly.fit_transform(X.reshape(-1, 1))
        poly_scaled = self.scaler.transform(poly_features)

        return self.regressor.predict(poly_scaled)


def generate_data(m, seed=1, scale=0.7):
    """ generate a data set based on a x^2 with added noise """
    c = 0
    x_train = np.linspace(0,49,m)
    np.random.seed(seed)
    y_ideal = x_train**2 + c
    y_train = y_ideal + scale * y_ideal*(np.random.sample((m,))-0.5)
    x_ideal = np.linspace(0,49,200)
    y_ideal = x_ideal**2 + c
    
    return x_train, y_train, x_ideal, y_ideal