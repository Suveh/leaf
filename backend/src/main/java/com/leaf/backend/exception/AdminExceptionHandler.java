package com.leaf.backend.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import com.leaf.backend.controller.AdminCareLogController;
import com.leaf.backend.controller.AdminPlantController;
import com.leaf.backend.controller.AdminReminderController;

@ControllerAdvice(assignableTypes = {AdminPlantController.class, AdminCareLogController.class, AdminReminderController.class})
public class AdminExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ModelAndView handleNotFound(ResourceNotFoundException ex) {
        ModelAndView modelAndView = new ModelAndView("admin/error");
        modelAndView.addObject("message", ex.getMessage());
        modelAndView.setStatus(HttpStatus.NOT_FOUND);
        return modelAndView;
    }
}
