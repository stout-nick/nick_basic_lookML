view: order_items {
  sql_table_name: `looker-private-demo.thelook.order_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: Sales_Price_Words {
    case: {
      when: {
        sql: ${sale_price} < 250 ;;
        label: "POOR"
      }
      when: {
        sql: ${sale_price} between 251 and 700 ;;
        label: "Ehhh"
      }
      else: "Rich"
    }
  }


  measure: total_sales_price {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: total_large_sales_price {
    type: sum
    value_format_name: usd
    filters: [order_items.sale_price: ">100"]
    sql: ${sale_price};;
  }

  dimension: gross_margin {
    label: "Gross Margin"
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost};;
  }

  measure: average_sales_per_user{
      type: number
      value_format_name: usd
      sql:1.0 * ${total_sales_price}/NULLIF(${users.count},0) ;;

  }

  measure: total_gross_margin {
    type: sum
    value_format_name: usd
    sql: ${gross_margin} ;;
  }

  measure: item_gross_margin_percentage {
    label: "Item Gross Margin %"
    value_format_name: percent_2
    sql: 1.0 * ${gross_margin}/NULLIF(${sale_price},0) ;;
  }

  measure: average_gross_margin {
    type: average
    value_format_name: usd
    sql: ${gross_margin} ;;
  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      orders.order_id
    ]
  }
}
