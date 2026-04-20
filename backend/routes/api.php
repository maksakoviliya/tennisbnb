<?php

use App\Http\Controllers\Api\V1\BookingController;
use App\Http\Controllers\Api\V1\CourtController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    // Public routes
    Route::get('/courts', [CourtController::class, 'index']);
    Route::get('/courts/{id}', [CourtController::class, 'show']);

    // Booking routes
    Route::post('/bookings', [BookingController::class, 'store']);
    Route::get('/bookings/my', [BookingController::class, 'myBookings']);
    Route::post('/bookings/{id}/cancel', [BookingController::class, 'cancel']);
});
