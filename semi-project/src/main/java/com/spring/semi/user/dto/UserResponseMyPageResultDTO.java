package com.spring.semi.user.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
@EqualsAndHashCode
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserResponseMyPageResultDTO {
	
	private int rn;
	private int bno;
	private LocalDateTime regDate;
	private String location;
	private String jobCategory1;
	private String jobCategory2;
	private String jobCategory3;
	private int budget;
}
