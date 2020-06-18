package org.uyi.h.web.model;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;


@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name="page")
public class Page<E>{
	
	private int total;// 总记录数
	
	private List<E> rows;// 记录
	
	private List<E> footer;// 统计
	
	//privae 

	public List<E> getFooter() {
		return footer;
	}

	public void setFooter(List<E> footer) {
		this.footer = footer;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

//	@XmlAnyElement(lax = true)
	public List<E> getRows() {
		return rows;
	}

	public void setRows(List<E> rows) {
		this.rows = rows;
	}
	

}
