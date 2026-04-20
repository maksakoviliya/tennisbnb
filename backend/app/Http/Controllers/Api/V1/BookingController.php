<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Court;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class BookingController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'court_id' => 'required|exists:courts,id',
            'guest_name' => 'required|string|max:255',
            'guest_email' => 'required|email|max:255',
            'guest_phone' => 'required|string|max:50',
            'booking_date' => 'required|date|after_or_equal:today',
            'start_time' => 'required|date_format:H:i',
            'end_time' => 'required|date_format:H:i|after:start_time',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors(),
            ], 422);
        }

        // Check if court is available on that date/time
        $court = Court::find($request->court_id);
        if (!$court->is_available) {
            return response()->json([
                'success' => false,
                'message' => 'Court is not available',
            ], 400);
        }

        // Check for overlapping bookings
        $exists = Booking::where('court_id', $request->court_id)
            ->where('booking_date', $request->booking_date)
            ->whereIn('status', ['pending', 'confirmed'])
            ->where(function ($query) use ($request) {
                $query->whereBetween('start_time', [$request->start_time, $request->end_time])
                    ->orWhereBetween('end_time', [$request->start_time, $request->end_time])
                    ->orWhere(function ($q) use ($request) {
                        $q->where('start_time', '<=', $request->start_time)
                          ->where('end_time', '>=', $request->end_time);
                    });
            })->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => 'Time slot is already booked',
            ], 409);
        }

        // Calculate price
        $price = $court->prices()->where('price_type', 'hourly')->first();
        $hours = (strtotime($request->end_time) - strtotime($request->start_time)) / 3600;
        $totalPrice = $price ? $price->price * $hours : 0;

        $booking = Booking::create([
            'court_id' => $request->court_id,
            'guest_name' => $request->guest_name,
            'guest_email' => $request->guest_email,
            'guest_phone' => $request->guest_phone,
            'booking_date' => $request->booking_date,
            'start_time' => $request->start_time,
            'end_time' => $request->end_time,
            'total_price' => $totalPrice,
            'status' => 'pending',
            'notes' => $request->notes,
        ]);

        return response()->json([
            'success' => true,
            'data' => $booking,
            'message' => 'Booking created successfully',
        ], 201);
    }

    public function myBookings(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors(),
            ], 422);
        }

        $bookings = Booking::where('guest_email', $request->email)
            ->with('court')
            ->orderBy('booking_date', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $bookings,
        ]);
    }

    public function cancel(int $id, Request $request): JsonResponse
    {
        $booking = Booking::find($id);

        if (!$booking) {
            return response()->json([
                'success' => false,
                'message' => 'Booking not found',
            ], 404);
        }

        // Verify ownership via email
        if ($booking->guest_email !== $request->input('email')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        if ($booking->status === 'cancelled') {
            return response()->json([
                'success' => false,
                'message' => 'Booking is already cancelled',
            ], 400);
        }

        $booking->update(['status' => 'cancelled']);

        return response()->json([
            'success' => true,
            'message' => 'Booking cancelled successfully',
        ]);
    }
}
