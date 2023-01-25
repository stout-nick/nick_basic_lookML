connection: "looker-private-demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together

datagroup: nicks_datagroup {
  max_cache_age: "24 hours"
  sql_trigger: SELECT max(id) FROM my_tablename ;;
  interval_trigger: "4 hours"
  label: "nick basic cache"
  description: "4 hour cache"
}

  explore: order_items {
    sql_always_where: ${orders.created_date} >= '2021-01-01' ;;
    join: orders {
      fields: [users.last_name, users.last_name, order_items.id, orders.count]
     relationship: many_to_one
     sql_on: ${orders.order_id} = ${order_items.order_id} ;;
   }
    join: inventory_items {
      relationship: many_to_one
      sql_on: ${order_items.inventory_item_id}.id} = ${inventory_items.id} ;;
    }

   join: users {
     relationship: many_to_one
     sql_on: ${users.id} = ${orders.user_id} ;;
   }
 }

 explore: products {
  always_filter: {
    filters: [products.category: "Shirts"]
  }
  join: inventory_items {
    relationship: one_to_many #how do you remember relationships, many to one vs one to many
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
    type: inner
  }
}
explore: distribution_centers{
  join: inventory_items {
    relationship: many_to_one
    view_label: "Distribution Centers with Stock"
    sql_on: ${distribution_centers.id} = ${inventory_items.product_distribution_center_id} ;;
    type: inner

  }
}

#i know these dimensions and measures go into the appropriate view files - but putting them here to centralize

# dimension:  sale_price {
#  type: number
#  sql: ${TABLE}.sale_price ;;
#}

# dimension:  gender {
#  type: string
#  sql: ${TABLE}.gender ;;
#}

# dimension: status {
#  case: {
#    when: {
#      sql: ${TABLE}.status = 0 ;;
#      label: "pending"
#    }
#    when: {
#      sql: ${TABLE}.status = 1 ;;
#      label: "complete"
#    }
#    when: {
#      sql: ${TABLE}.status = 2 ;;
#      label: "canceled"
#    }
#    else: "unknown"
#  }
#}

# dimension:  age_tier {
#  type:  tier
#  style: integer
#  tiers: [0,10, 20, 30, 40, 50, 60, 70, 80, 90]
#  sql: ${age} ;;
# }
#  type: yesno
#  sql: ${status} = 'paid' ;;
# }
#
# dimension:  zipcode {
#  type:  zipcode
#  sql: ${TABLE}.zipcode ;;
# }
#
#   measure: total_sales {
#     type: sum
#     sql: ${TABLE}.sale_price ;;
#   }
#
#   measure: min_sales {
#     type: min
#     sql: ${TABLE}.sale_price ;;
#   }
#
#   measure: max_sales {
#     type: max
#     sql: ${TABLE}.sale_price ;;
#   }
#
#   measure: average_sales {
#     sql: ${TABLE}.sale_price ;;
#   }
# }
