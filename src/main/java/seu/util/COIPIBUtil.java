package seu.util;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

public class COIPIBUtil {
    private static final Logger LOGGER = LoggerFactory.getLogger(COIPIBUtil.class);

    public static String getAPPURL(HttpServletRequest request){
        String context = request.getContextPath();
        String requestURL = request.getRequestURL().toString();
        String[] splits = StringUtils.split(requestURL, "/");
        if (StringUtils.isNotBlank(context)) {
            return splits[0] + "//" + splits[1] + "/" + splits[2] + "/";
        } else {
            return splits[0] + "//" + splits[1] + "/";
        }
    }
}
