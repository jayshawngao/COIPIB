package seu.base;

public class PageInfo {
    private int rowTotal;// 总记录数
    private int pageSize = 30;// 每页记录数
    private int page;// 当前页码，从1开始
    private int total;// 总页数
    private int beginIndex;//起始记录下标
    private int endIndex;//截止记录下标


    public PageInfo(int totalRow, int page) {
        this.rowTotal = totalRow;
        this.page = page;
        calculate();
    }


    public PageInfo(int totalRow, int page, int pageSize) {
        this.rowTotal = totalRow;
        this.page = page;
        this.pageSize = pageSize;
        calculate();
    }

    private void calculate() {
        total = rowTotal / pageSize + ((rowTotal % pageSize) > 0 ? 1 : 0);

        if (page > total) {
            page = total;
        } else if (page < 1) {
            page = 1;
        }

        beginIndex = (page - 1) * pageSize ;
        endIndex = beginIndex + pageSize ;
        if (endIndex > rowTotal) {
            endIndex = rowTotal;
        }
    }

    public int getPage() {
        return page;
    }

    public int getTotal() {
        return total;
    }

    public int getTotalRow() {
        return rowTotal;
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
                "rowTotal=" + rowTotal +
                ", pageSize=" + pageSize +
                ", page=" + page +
                ", total=" + total +
                ", beginIndex=" + beginIndex +
                ", endIndex=" + endIndex +
                '}';
    }
}
