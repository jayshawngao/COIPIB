package seu.base;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.HashMap;
import java.util.Random;
import java.util.Map;

public class CodeCaptchaServlet extends HttpServlet {
    public static final String VALIDATION_CODE = "VALIDATION_CODE";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getSession().removeAttribute(VALIDATION_CODE);
        // 首先设置页面不缓存
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);

        // 在内存中创建图像
        int iWidth = 113;
        int iHeight = 45;
        BufferedImage image = new BufferedImage(iWidth, iHeight, BufferedImage.TYPE_INT_RGB);

        // 获取图像上下文
        Graphics g = image.getGraphics();

        // 设定背景颜色
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, iWidth, iHeight);

        // 画边框
        g.setColor(Color.BLACK);
        g.drawRect(0, 0, iWidth, iHeight);

        // 去随机产生的验证码（4位数）
        int iniCount = 0;
        iniCount = (new Random()).nextInt(9999);
        if (iniCount < 1000) {
            iniCount += 1000;
        }
        String rand = iniCount + "";

        // 将验证码显示到图像中
        g.setColor(Color.BLACK);
        g.setFont(new Font("宋体", Font.BOLD, 40));
        g.drawString(rand, 5, 35);

        // 随机产生100个干扰点，使图像中的验证码不易被其他程序探测到
        Map<Integer, Color> colors = new HashMap<>();
        colors.put(0, Color.RED);
        colors.put(1, Color.BLACK);
        colors.put(2, Color.GREEN);
        colors.put(3, Color.YELLOW);
        colors.put(4, Color.BLUE);
        colors.put(5, Color.PINK);
        colors.put(6, Color.GRAY);
        colors.put(7, Color.ORANGE);
        colors.put(8, Color.cyan);
        colors.put(9, Color.MAGENTA);
        Random random = new Random();
        for (int i = 0; i < 1000; i++) {
            int x = random.nextInt(iWidth);
            int y = random.nextInt(iHeight);
            int colorIndex = random.nextInt(10);
            g.setColor(colors.get(colorIndex));
            g.drawLine(x, y, x, y);
        }

        // 将生成的随机字符串写入Session
        request.getSession().setAttribute(VALIDATION_CODE, rand);

        // 图像生效
        g.dispose();

        // 输出图像到页面
        ImageIO.write(image, "JPEG", response.getOutputStream());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }

    @Override
    public void init() throws ServletException {
        super.init();
    }
}
