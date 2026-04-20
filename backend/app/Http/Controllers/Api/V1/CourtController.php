<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Court;
use Illuminate\Http\JsonResponse;

class CourtController extends Controller
{
    public function index(): JsonResponse
    {
        $courts = Court::where('is_available', true)
            ->with(['prices', 'schedules'])
            ->get();

        return response()->json([
            'success' => true,
            'data' => $courts,
        ]);
    }

    public function show(int $id): JsonResponse
    {
        $court = Court::with(['prices', 'schedules', 'bookings' => function ($query) {
            $query->where('booking_date', '>=', now()->toDateString())
                  ->whereIn('status', ['pending', 'confirmed']);
        }])->find($id);

        if (!$court) {
            return response()->json([
                'success' => false,
                'message' => 'Court not found',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $court,
        ]);
    }
}
