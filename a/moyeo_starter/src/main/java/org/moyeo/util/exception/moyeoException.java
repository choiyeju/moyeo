package org.moyeo.util.exception;

public class moyeoException extends RuntimeException {
	/**
	 * 
	 */
	private static final long serialVersionUID = -138261170711515101L;
	public moyeoException(){
		super();
	}
	public moyeoException(String message){
		super(message);
	}
	public moyeoException(String message, Throwable cause){
		super(message, cause);
	}
}
