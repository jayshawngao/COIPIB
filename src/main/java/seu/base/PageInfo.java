package seu.base;

public class PageInfo {
    private int totalRow;// 总记录数
    private int pageSize = 20;// 每页记录数
    private int page;// 当前页码，从1开始
    private int totalPage;// 总页数
    private int beginIndex;//起始记录下标
    private int endIndex;//截止记录下标


    public PageInfo(int totalRow, int page) {
        this.totalRow = totalRow;
        this.page = page;
        calculate();
    }


    public PageInfo(int totalRow, int page, int pageSize) {
        this.totalRow = totalRow;
        this.page = page;
        this.pageSize = pageSize;
        calculate();
    }

    private void calculate() {
        totalPage = totalRow / pageSize + ((totalRow % pageSize) > 0 ? 1 : 0);

        if (page > totalPage && totalPage != 0) {
            page = totalPage;
        } else if (page < 1) {
            page = 1;
        }

        beginIndex = (page - 1) * pageSize ;
        endIndex = beginIndex + pageSize ;
        if (endIndex > totalRow) {
            endIndex = totalRow;
        }
    }

    public int getPage() {
        return page;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public int getTotalRow() {
        return totalRow;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getBeginIndex() {
        return beginIndex;
    }

    public int getEndIndex() {
        return endIndex;
    }

    @Override
    public String toString() {
        return "PageInfo{" +
                "totalRow=" + totalRow +
                ", pageSize=" + pageSize +
                ", page=" + page +
                ", totalPage=" + totalPage +
                ", beginIndex=" + beginIndex +
                ", endIndex=" + endIndex +
                '}';
    }
}
