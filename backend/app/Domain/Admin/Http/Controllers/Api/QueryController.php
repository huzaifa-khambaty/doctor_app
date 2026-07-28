<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Domain\Shared\Models\Query;
use App\Domain\Shared\Models\QueryCategory;
use Illuminate\Http\Request;

class QueryController extends Controller
{
    // ... existing query methods ...

    // Category CRUD
    public function categories(Request $request)
    {
        $categories = QueryCategory::select('id', 'name', 'slug')->orderBy('name')->get();
        return response()->json($categories);
    }

    public function storeCategory(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:query_categories,name',
            'slug' => 'required|string|max:255|unique:query_categories,slug',
        ]);

        $category = QueryCategory::create([
            'name' => $request->name,
            'slug' => $request->slug,
        ]);

        return response()->json([
            'message' => 'Category created successfully.',
            'data' => $category,
        ], 201);
    }

    public function updateCategory(Request $request, QueryCategory $category)
    {
        $request->validate([
            'name' => 'sometimes|required|string|max:255|unique:query_categories,name,' . $category->id,
            'slug' => 'sometimes|required|string|max:255|unique:query_categories,slug,' . $category->id,
        ]);

        $category->update($request->only(['name', 'slug']));

        return response()->json([
            'message' => 'Category updated successfully.',
            'data' => $category,
        ]);
    }

    public function deleteCategory(QueryCategory $category)
    {
        if ($category->queries()->exists()) {
            return response()->json([
                'message' => 'Cannot delete category with existing queries.',
            ], 422);
        }

        $category->delete();

        return response()->json(['message' => 'Category deleted successfully.']);
    }
}
