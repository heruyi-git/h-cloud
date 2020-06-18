package org.uyi.h.common.vo.result;


import javax.xml.bind.annotation.*;
import java.util.Arrays;
import java.util.Date;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement
public class Result<T> {

	private long timestamp = System.currentTimeMillis();

	private int code;

	private String msg;

	private T data;

	public Result() {
	}

	public Result(Code code) {
		this.code = code.value();
		this.msg = code.desc();
	}

	public Result(Code code, String msg) {
		this.code = code.value();
		this.msg = msg;
	}
	
	public T getData() {
		return data;
	}

	public void setData(T data) {
		this.data = data;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public long getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}

	public Result putCode(Code code) {
		if (code != null) {
			this.code = code.value();
			// if (CheckData.isEmpty(this.msg)) {
				this.msg = code.desc();
			// }
		}
		return this;
	}

	@Override
	public String toString() {
		return "Result{" +
				"timestamp=" + timestamp +
				", code=" + code +
				", msg='" + msg + '\'' +
				", data=" + data +
				'}';
	}


}
