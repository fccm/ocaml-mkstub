#include <algorithm>

class CRectangle1 {
    int x, y;
} rect1;

class CRectangle2 {
    int x, y;
  public:
    void set_values (int, int);
    int area (void);
} rect2;

class CRectangle3 {
    int x, y;
  public:
    CRectangle3();
    CRectangle3(int left, int top, int width, int height);
    void set_values (int, int);
    int area (void);
} rect3;

/*
struct JoystickState
{
    JoystickState()
    {
        connected = false;
        std::fill(axes, axes + 4, 0.f);
        std::fill(buttons, buttons + 16, false);
    }

    bool  connected;
    float axes[4];
    bool  buttons[16];
};
*/
