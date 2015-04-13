import numpy as np
import matplotlib.pyplot as plt
from control import *    # MATLAB-like functions
from control.matlab import *    # MATLAB-like functions
import seaborn as sns


np.set_printoptions(formatter={'float': '{:+0.3e}'.format,
                               'complexfloat': '{:+.3e}'.format})

# Flight condition 8901
# h = 20000
# M = 0.638

g = 32.2
theta_0 = 0
u_0 = 669.8


def longitudinal_ss(step=False):
    # Longitudinal dimensional derivatives
    X_u = -0.0097
    X_w = 0.0016
    X_d_e = 0
    Z_u = -0.0955
    Z_wdot = 0  # This value is not clear, assuming as 0
    Z_w = -1.43
    Z_d_e = -69.8
    M_u = 0
    M_wdot = -0.0013
    M_w = -0.0235
    M_q = -1.92
    M_d_e = -26.1

    # No data available, assumed to be 0
    Z_q = 0

    # Define state state space representations
    A = np.array(
        [[X_u, X_w, 0, -g*np.cos(theta_0), 0],
         [Z_u/(1-Z_wdot), Z_w/(1-Z_wdot), (Z_q + u_0)/(1-Z_wdot), -g*np.sin(theta_0)/(1-Z_wdot), 0],
         [M_u + (M_wdot * Z_u)/(1-Z_wdot), M_w + (M_wdot * Z_w)/(1-Z_wdot), M_q + (M_wdot*(Z_q+u_0))/(1-Z_wdot), -M_wdot*g*np.sin(theta_0)/(1-Z_wdot), 0],
         [0, 0, 1, 0, 0],
         [0, -1, 0, u_0, 0]])

    if step:
        B = 5/57.3 * np.array(
            [[X_d_e],
             [Z_d_e/(1-Z_wdot)],
             [M_wdot*Z_d_e/(1-Z_wdot) + M_d_e],
             [0],
             [0]])

        C = np.array(
            [[0, 0, 1, 0, 0],
             [0, 0, 0, 0, 1]])

        D = np.array([[0], [0]])
        return ss(A, B, C, D)

    else:
        B = np.array(
            [[0],
             [0],
             [0],
             [0],
             [0]])

        C = np.array(
            [[1, 0, 0, 0, 0],
             [0, 1/u_0, 0, 0, 0],
             [0, 0, 1, 0, 0],
             [0, 0, 0, 1, 0],
             [0, 0, 0, 0, 1]])

        D = np.array([[0], [0], [0], [0], [0]])
        return A, B, C, D


def lateral_ss(step=False):
    # Lateral dimensional derivatives
    Y_v = -0.0829
    Y_d_a = 0
    L_p_prime = -1.70
    L_r_prime = 0.172
    L_d_a_prime = 27.3
    N_p_prime = -0.0654
    N_r_prime = -0.0893
    N_d_a_prime = 0.395

    # No data available, assumed 0
    Y_p = 0
    Y_r = 0
    L_v_prime = 0
    N_v_prime = 0

    # Define state state space representations
    A = np.array([[Y_v, Y_p, Y_r - u_0, g * np.cos(theta_0), 0],
                  [L_v_prime, L_p_prime, L_r_prime, 0, 0],
                  [N_v_prime, N_p_prime, N_r_prime, 0, 0],
                  [0, 1, np.tan(theta_0), 0, 0],
                  [0, 0, np.arccos(theta_0), 0, 0]])

    if step:
        B = 5/57.3 * np.array(
            [[Y_d_a],
             [L_d_a_prime],
             [N_d_a_prime],
             [0],
             [0]])

        C = np.array(
            [[0, 0, 1, 0, 0],
             [0, 0, 0, 0, 1]])

        D = np.array([[0], [0]])
        return ss(A, B, C, D)

    else:
        B = np.array(
            [[0],
             [0],
             [0],
             [0],
             [0]])

        C = np.array([[1/u_0, 0, 0, 0, 0],
                      [0, 1, 0, 0, 0],
                      [0, 0, 1, 0, 0],
                      [0, 0, 0, 1, 0],
                      [0, 0, 0, 0, 1]])

        D = np.array([[0], [0], [0], [0], [0]])
        return A, B, C, D


def long_step_plot():
    F89_long = longitudinal_ss(step=True)
    (y, t) = step(F89_long, T=linspace(0, 200, 10000))

    fig, (ax1, ax2) = plt.subplots(2)
    ax1.plot(t, y[:, 1], 'b-')
    ax1.set_xlabel('Time (s)')
    ax1.set_ylabel('$\Delta h$', color='b')
    for tl in ax1.get_yticklabels():
        tl.set_color('b')

    ax1twinx = ax1.twinx()
    ax1twinx.plot(t, y[:, 0], 'r--')
    ax1twinx.set_ylabel('$\Delta \\theta$', color='r')
    for tl in ax1twinx.get_yticklabels():
        tl.set_color('r')
    plt.xlim(0, t[-1])

    t_trunc, y_trunc = t[:1000], y[:1000]
    ax2.plot(t_trunc, y_trunc[:, 1], 'b-')
    ax2.set_xlabel('Time (s)')
    ax2.set_ylabel('$\Delta h$', color='b')
    for tl in ax2.get_yticklabels():
        tl.set_color('b')

    ax2twinx = ax2.twinx()
    ax2twinx.plot(t_trunc, y_trunc[:, 0], 'r--')
    ax2twinx.set_ylabel('$\Delta \\theta$', color='r')
    for tl in ax2twinx.get_yticklabels():
        tl.set_color('r')
    plt.xlim(0, t[1000 - 1])

    plt.tight_layout()
    plt.show()


def lat_step_plot():
    F89_lat = lateral_ss(step=True)
    (y, t) = step(F89_lat, T=linspace(0, 200, 20000))

    fig, (ax1, ax2) = plt.subplots(2)
    ax1.plot(t, y[:, 1], 'b-')
    ax1.set_xlabel('Time (s)')
    ax1.set_ylabel('$\Delta \Phi$', color='b')
    for tl in ax1.get_yticklabels():
        tl.set_color('b')

    ax1twinx = ax1.twinx()
    ax1twinx.plot(t, y[:, 0], 'r--')
    ax1twinx.set_ylabel('$\Delta r$', color='r')
    for tl in ax1twinx.get_yticklabels():
        tl.set_color('r')
    plt.xlim(0, t[-1])

    t_trunc, y_trunc = t[:200], y[:200]
    ax2.plot(t_trunc, y_trunc[:, 1], 'b-')
    ax2.set_xlabel('Time (s)')
    ax2.set_ylabel('$\Delta \Phi$', color='b')
    for tl in ax2.get_yticklabels():
        tl.set_color('b')

    ax2twinx = ax2.twinx()
    ax2twinx.plot(t_trunc, y_trunc[:, 0], 'r--')
    ax2twinx.set_ylabel('$\Delta r$', color='r')
    for tl in ax2twinx.get_yticklabels():
        tl.set_color('r')
    plt.xlim(0, t[200 - 1])

    plt.tight_layout()
    plt.show()


def long_initial_plot():
    print("Longitudinal")
    A, B, C, D = longitudinal_ss()
    v, d = np.linalg.eig(A)

    F89 = ss(A, B, C, D)
    for i in [0, 2, 3]:
        ic_i = np.real(d[:, i])
        for length in [5, 1000]:
            print(v[i], ic_i, length)
            y, t = initial(F89, T=np.linspace(0, length, length*10), X0=ic_i)

            f, axes = plt.subplots(5, sharex=True)
            axes[0].plot(t, y[:, 0])
            axes[0].set_ylabel('$\Delta u$')
            axes[1].plot(t, y[:, 1])
            axes[1].set_ylabel('$\Delta \\alpha$')
            axes[2].plot(t, y[:, 2])
            axes[2].set_ylabel('$\Delta q$')
            axes[3].plot(t, y[:, 3])
            axes[3].set_ylabel('$\Delta \\theta$')
            axes[4].plot(t, y[:, 4])
            axes[4].set_ylabel('$\Delta h$')
            plt.xlabel('Time (s)')
            plt.tight_layout()
            plt.show()


def lat_initial_plot():
    print("Lateral")
    A, B, C, D = lateral_ss()
    v, d = np.linalg.eig(A)

    F89 = ss(A, B, C, D)
    for i in [0, 3, 4]:
        ic_i = np.real(d[:, i])
        for length in [5, 60]:
            y, t = initial(F89, T=np.linspace(0, length, length*10), X0=ic_i)
            print(v[i], ic_i, length)

            f, axes = plt.subplots(5, sharex=True)
            axes[0].plot(t, y[:, 0])
            axes[0].set_ylabel('$\Delta \\beta$')
            axes[1].plot(t, y[:, 1])
            axes[1].set_ylabel('$\Delta p$')
            axes[2].plot(t, y[:, 2])
            axes[2].set_ylabel('$\Delta r$')
            axes[3].plot(t, y[:, 3])
            axes[3].set_ylabel('$\Delta \phi$')
            axes[4].plot(t, y[:, 4])
            axes[4].set_ylabel('$\Delta \Psi$')
            plt.xlabel('Time (s)')
            plt.tight_layout()
            plt.show()


def part_one():
    print("Longitudinal")
    print(ss(*longitudinal_ss()))

    print("Lateral")
    print(ss(*lateral_ss()))

# Part 1
# part_one()

# Part 2
# long_initial_plot()
# lat_initial_plot()

# Part 3


# Part 4
# long_step_plot()
# lat_step_plot()
