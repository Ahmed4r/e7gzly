package com.example.e7gzly.model;

import jakarta.persistence.*;
@Entity
@Table(name = "clinics")
public class Clinic {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String address;

    private String phone;

    private String imageUrl;

    private Double latitude;

    private Double longitude;

    private String type;

    private Double rating;

    private Integer reviewsCount;

    private Integer departmentsCount;

    @Column(length = 3000)
    private String description;

    public Clinic() {
    }

    public Clinic(
            String name,
            String address,
            String phone,
            String imageUrl,
            Double latitude,
            Double longitude,
            String type,
            Double rating,
            Integer reviewsCount,
            Integer departmentsCount,
            String description
    ) {
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.imageUrl = imageUrl;
        this.latitude = latitude;
        this.longitude = longitude;
        this.type = type;
        this.rating = rating;
        this.reviewsCount = reviewsCount;
        this.departmentsCount = departmentsCount;
        this.description = description;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Double getRating() {
        return rating;
    }

    public void setRating(Double rating) {
        this.rating = rating;
    }

    public Integer getReviewsCount() {
        return reviewsCount;
    }

    public void setReviewsCount(Integer reviewsCount) {
        this.reviewsCount = reviewsCount;
    }

    public Integer getDepartmentsCount() {
        return departmentsCount;
    }

    public void setDepartmentsCount(Integer departmentsCount) {
        this.departmentsCount = departmentsCount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}