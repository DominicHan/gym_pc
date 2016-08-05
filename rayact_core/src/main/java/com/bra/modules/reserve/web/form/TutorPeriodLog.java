package com.bra.modules.reserve.web.form;

import com.bra.common.persistence.SaasEntity;
import com.bra.modules.reserve.entity.ReserveField;
import com.bra.modules.reserve.entity.ReserveVenue;

import java.util.Date;

/**
 * Created by xiaobin on 16/1/28.
 */
public class TutorPeriodLog extends SaasEntity<TutorPeriodLog> {

    private String id;

    private ReserveVenue venue;

    private ReserveField field;

    private String tutorName;

    private String username;

    private String startTime;

    private String endTime;

    private Date consDate;

    private Integer periodNum;

    public Integer getPeriodNum() {
        return periodNum;
    }

    public void setPeriodNum(Integer periodNum) {
        this.periodNum = periodNum;
    }

    public ReserveField getField() {
        return field;
    }

    public void setField(ReserveField field) {
        this.field = field;
    }


    @Override
    public String getId() {
        return id;
    }

    @Override
    public void setId(String id) {
        this.id = id;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public Date getConsDate() {
        return consDate;
    }

    public void setConsDate(Date consDate) {
        this.consDate = consDate;
    }

    public ReserveVenue getVenue() {
        return venue;
    }

    public void setVenue(ReserveVenue venue) {
        this.venue = venue;
    }

    public String getTutorName() {
        return tutorName;
    }

    public void setTutorName(String tutorName) {
        this.tutorName = tutorName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }


    //---------------------------------------------------------
    private Date startDate;
    private Date endDate;
    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    //--------------------------------------

}
