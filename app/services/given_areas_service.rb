# frozen_string_literal: true

class GivenAreasService
  def point_inside?(location_point)
    polygons.any? { |polygon| point_inside_polygon?(polygon, location_point) }
  end

  private

  def point_inside_polygon?(polygon, location_point)
    intersection_number = 0
    point_on_the_edge_times = 0

    polygon.points.each_with_index do |current_polygon_point, index|
      next if index.zero?

      antecedent_polygon_point = polygon.points[index - 1]

      next if location_point_outside_polygon_points_latitudes?(
        location_point,
        antecedent_polygon_point,
        current_polygon_point
      )

      intersection_longitude = intersection_longitude(location_point, antecedent_polygon_point, current_polygon_point)
      location_point_longitude = location_point.longitude

      point_on_the_edge_times += 1 if point_on_the_edge?(intersection_longitude, location_point_longitude)
      intersection_number += 1 if ray_itersects_polygon_edge?(intersection_longitude, location_point_longitude)
    end

    intersection_number.odd? || (intersection_number.zero? && point_on_the_edge_times.odd?)
  end

  def intersection_longitude(location_point, antecedent_polygon_point, current_polygon_point)
    intersection_longitude_raw = longitude_for_given_latitude(
      location_point.latitude,
      antecedent_polygon_point,
      current_polygon_point
    )

    round_intersection_longitude(intersection_longitude_raw, location_point.longitude)
  end

  def round_intersection_longitude(intersection_longitude_raw, location_point_longitude)
    decimal_places = (location_point_longitude.to_s.to_s[/\.\d+$/].try(:size) || 1) - 1
    intersection_longitude_raw.round(decimal_places)
  end

  def point_on_the_edge?(intersection_longitude, location_point_longitude)
    location_point_longitude == intersection_longitude
  end

  def ray_itersects_polygon_edge?(intersection_longitude, location_point_longitude)
    location_point_longitude < intersection_longitude
  end

  def longitude_for_given_latitude(given_latitude, point1, point2)
    (point1.longitude +
      ((point2.longitude - point1.longitude) * (given_latitude - point1.latitude)) /
        (point2.latitude - point1.latitude)
    )
  end

  def location_point_outside_polygon_points_latitudes?(location_point, antecedent_polygon_point, current_polygon_point)
    !(point_between_latitudes?(location_point, antecedent_polygon_point, current_polygon_point) ||
      point_between_latitudes?(location_point, current_polygon_point, antecedent_polygon_point))
  end

  def point_between_latitudes?(point, another_point1, another_point2)
    another_point1.latitude <= point.latitude && point.latitude < another_point2.latitude
  end

  def polygons
    return @polygons if @polygons.present?

    polygon_collection = ::GivenAreas::DataFromFile.read
    @polygons ||= polygon_collection['features'].map do |f|
      OpenStruct.new(
        points: generate_points(f['geometry']['coordinates'][0])
      )
    end
  end

  def generate_points(polygon_coordinates)
    polygon_coordinates.map do |coordinates|
      OpenStruct.new(
        longitude: coordinates[0],
        latitude: coordinates[1]
      )
    end
  end
end
